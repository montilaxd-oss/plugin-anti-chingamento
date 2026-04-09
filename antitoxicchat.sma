#include <amxmodx>
#include <amxmisc>
#include <amxmodx>

#define MAX_BAD_WORDS 500  // Número máximo de palavras banidas
#define MAX_WORD_LENGTH 32 // Tamanho máximo por palavra
#define CONFIG_FILE "addons/amxmodx/configs/antitoxic/badwords.ini"

// Variáveis globais
new Array:g_aBadWords;
new g_iTotalBadWords;
new g_iPlayerWarnings[33];

// Configurações de punição
#define MAX_WARNINGS 3     // Avisos antes de kickar
#define KICK_MESSAGE "Você foi kickado por linguagem ofensiva"

public plugin_init() {
    register_plugin("Anti-Toxic Chat", "2.0", "MontilaXD");
    
    // Cria o diretório se não existir
    if(!dir_exists("addons/amxmodx/configs/antitoxic")) {
        mkdir("addons/amxmodx/configs/antitoxic");
    }
    
    // Cria arquivo padrão se não existir
    if(!file_exists(CONFIG_FILE)) {
        write_default_words();
    }
    
    // Inicializa array para palavras banidas
    g_aBadWords = ArrayCreate(MAX_WORD_LENGTH);
    
    // Carrega palavras banidas
    load_bad_words();
    
    // Registra comandos
    register_clcmd("say", "HandleChat");
    register_clcmd("say_team", "HandleChat");
    
    // Mensagem de aviso
    register_event("ResetHUD", "OnPlayerSpawn", "be");
}

public plugin_end() {
    ArrayDestroy(g_aBadWords);
}

public OnPlayerSpawn(id) {
    if(is_user_connected(id)) {
        client_print(id, print_chat, "[ANTI-TOXICO] Chat monitorado: Evite xingamentos e racismo!");
    }
}

load_bad_words() {
    // Limpa array se já tiver conteúdo
    if(ArraySize(g_aBadWords) > 0) {
        ArrayClear(g_aBadWords);
    }
    
    new iFile = fopen(CONFIG_FILE, "rt");
    if(!iFile) {
        log_amx("Erro ao carregar arquivo de palavras banidas: %s", CONFIG_FILE);
        return;
    }
    
    new szBuffer[MAX_WORD_LENGTH];
    g_iTotalBadWords = 0;
    
    while(!feof(iFile) && g_iTotalBadWords < MAX_BAD_WORDS) {
        fgets(iFile, szBuffer, charsmax(szBuffer));
        trim(szBuffer);
        
        // Ignora linhas vazias e comentários
        if(!szBuffer[0] || szBuffer[0] == ';' || szBuffer[0] == '#')
            continue;
            
        // Converte para minúsculas
        strtolower(szBuffer);
        
        // Adiciona ao array
        ArrayPushString(g_aBadWords, szBuffer);
        g_iTotalBadWords++;
    }
    
    fclose(iFile);
    
    if(g_iTotalBadWords >= MAX_BAD_WORDS) {
        log_amx("Aviso: Limite de %d palavras banidas atingido", MAX_BAD_WORDS);
    }
    
    server_print("[ANTI-TOXICO] Carregadas %d palavras banidas", g_iTotalBadWords);
}

write_default_words() {
    new iFile = fopen(CONFIG_FILE, "wt");
    if(!iFile) {
        log_amx("Erro ao criar arquivo padrão de palavras banidas");
        return;
    }
    
    fputs(iFile, "; Arquivo de palavras banidas para o plugin Anti-Toxic^n");
    fputs(iFile, "; Adicione uma palavra por linha^n");
    fputs(iFile, "; Comentários começam com ';' ou '#'^n^n");
    
    // Palavras padrão
    fputs(iFile, "caralho^n");
    fputs(iFile, "porra^n");
    fputs(iFile, "viado^n");
    fputs(iFile, "bicha^n");
    fputs(iFile, "preto^n");
    fputs(iFile, "macaco^n");
    fputs(iFile, "judeu^n");
    fputs(iFile, "nazista^n");
    fputs(iFile, "retardado^n");
    fputs(iFile, "vai se fuder^n");
    fputs(iFile, "vsf^n");
    fputs(iFile, "puta^n");
    fputs(iFile, "buceta^n");
    
    fclose(iFile);
}

public HandleChat(id) {
    if(!is_user_connected(id) || is_user_bot(id) || is_user_hltv(id))
        return PLUGIN_CONTINUE;
    
    new szMessage[192];
    read_args(szMessage, charsmax(szMessage));
    remove_quotes(szMessage);
    trim(szMessage);
    
    if(!szMessage[0])
        return PLUGIN_CONTINUE;
    
    new szLowerMessage[192];
    copy(szLowerMessage, charsmax(szLowerMessage), szMessage);
    strtolower(szLowerMessage);
    
    // Verifica contra palavras banidas
    new szCurrentWord[MAX_WORD_LENGTH];
    new bool:bFoundBadWord = false;
    
    for(new i = 0; i < g_iTotalBadWords; i++) {
        ArrayGetString(g_aBadWords, i, szCurrentWord, charsmax(szCurrentWord));
        
        if(contain(szLowerMessage, szCurrentWord) != -1) {
            bFoundBadWord = true;
            break;
        }
    }
    
    if(bFoundBadWord) {
        g_iPlayerWarnings[id]++;
        
        // Avisa o jogador
        client_print(id, print_chat, "[AVISO %d/%d] Evite linguagem ofensiva!", g_iPlayerWarnings[id], MAX_WARNINGS);
        
        // Avisa a todos
        new szName[32];
        get_user_name(id, szName, charsmax(szName));
        client_print(0, print_chat, "[ANTI-TOXICO] %s foi advertido por mensagem inapropriada", szName);
        
        // Kicka após vários avisos
        if(g_iPlayerWarnings[id] >= MAX_WARNINGS) {
            server_cmd("kick #%d ^"%s^"", get_user_userid(id), KICK_MESSAGE);
            g_iPlayerWarnings[id] = 0;
        }
        
        return PLUGIN_HANDLED;
    }
    
    return PLUGIN_CONTINUE;
}
