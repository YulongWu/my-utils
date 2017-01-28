from math import log
import math
def log2(a):
    return log(a)/log(2)

def ln(a):
    return log(a)/log(math.e)

def info(p):
    np = 1-p
    return - p * log2(p) - np * log2(np)

