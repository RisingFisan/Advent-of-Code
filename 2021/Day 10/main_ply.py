from sys import argv

# pip install ply
import ply.lex as lex
import ply.yacc as yacc

with open(argv[1] if len(argv) > 1 else 'input') as f:
    lines = f.readlines()

score = 0
scoreboard = {
    ')': 3,
    ']': 57,
    '}': 1197,
    '>': 25137
}

tokens = (
    'OP', # open parantheses
    'CP', # close parantheses
    'OB', # open brackets
    'CB', # close brackets
    'OC', # open curly brackets
    'CC', # close curly brackets
    'OA', # open angle brackets
    'CA', # close angle brackets
    'END'
)

t_OP = r'\('
t_CP = r'\)'
t_OB = r'\['
t_CB = r'\]'
t_OC = r'\{'
t_CC = r'\}'
t_OA = r'\<'
t_CA = r'\>'

# EOF handling rule
def t_eof(t):
    t.type = 'END'
    return t

def p_line(p):
    '''line : chunks'''
    print("Valid line")
    p[0] = p[1]

def p_chunks(p):
    '''chunks : chunks chunk
              | chunk'''
    p[0] = p[1] + (p[2] if len(p) > 2 else 0)

def p_chunk(p):
    """chunk : OP chunks CP
             | OB chunks CB
             | OC chunks CC
             | OA chunks CA"""
    p[0] = p[2]

def p_chunk_2(p):
    """chunk : OP CP
             | OB CB
             | OC CC
             | OA CA"""
    p[0] = 0

def p_chunk_error_P(p):
    """chunk : OP chunks CB
             | OP chunks CC
             | OP chunks CA
             | OP CB
             | OP CC
             | OP CA"""
    char = p[3] if type(p[2]) == int else p[2]
    print(f"Expected `)`, but found `{char}` instead.")
    p[0] = scoreboard[char] + (p[2] if type(p[2]) == int else 0)

def p_chunk_error_B(p):
    """chunk : OB chunks CP
             | OB chunks CC
             | OB chunks CA
             | OB CP
             | OB CC
             | OB CA"""
    char = p[3] if type(p[2]) == int else p[2]
    print(f"Expected `]`, but found `{char}` instead.")
    p[0] = scoreboard[char] + (p[2] if type(p[2]) == int else 0)

def p_chunk_error_C(p):
    """chunk : OC chunks CB
             | OC chunks CP
             | OC chunks CA
             | OC CB
             | OC CP
             | OC CA"""
    char = p[3] if type(p[2]) == int else p[2]
    print(f"Expected `}}`, but found `{char}` instead.")
    p[0] = scoreboard[char] + (p[2] if type(p[2]) == int else 0)    

def p_chunk_error_A(p):
    """chunk : OA chunks CB
             | OA chunks CC
             | OA chunks CP
             | OA CB
             | OA CC
             | OA CP"""
    char = p[3] if type(p[2]) == int else p[2]
    print(f"Expected `>`, but found `{char}` instead.")
    p[0] = scoreboard[char] + (p[2] if type(p[2]) == int else 0)

lexer = lex.lex()
parser = yacc.yacc()

# for i, line in enumerate(lines):
#     print(f"Line {i}:")
result = parser.parse(lines[2].strip(), debug=True)
print(result)