# Makefile para o analisador sintático e léxico

# Compilador e flags
CC = gcc
CFLAGS = -Wall -Wno-unused-function

# Arquivos principais
LEXER = lexer.l
PARSER = parser.y

# Saídas intermediárias
LEX_C = lex.yy.c
PARSER_C = parser.tab.c
PARSER_H = parser.tab.h

# Executável final
TARGET = parser

# Regra padrão
all: $(TARGET)

# Geração do executável
$(TARGET): $(LEX_C) $(PARSER_C)
	$(CC) $(CFLAGS) $(PARSER_C) $(LEX_C) -o $(TARGET) -lfl

# Geração do código do parser
$(PARSER_C) $(PARSER_H): $(PARSER)
	bison -d $(PARSER)

# Geração do código do lexer
$(LEX_C): $(LEXER)
	flex $(LEXER)

# Limpeza dos arquivos intermediários
clean:
	rm -f $(LEX_C) $(PARSER_C) $(PARSER_H) $(TARGET)

# Limpeza total (incluindo o executável)
mrproper: clean
	rm -f $(TARGET)
