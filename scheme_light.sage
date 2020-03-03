load("scheme.sage")

def lightCheck2(P):
    if P.is_zero(): return False
    if not (P[0] in Fp2 and P[1] in Fp2): return False
    if not P in TE: return False
    return True
def checkAlt(c): return check(c, lightCheck2)
rerandAlt = rerand
decAlt = dec
shuffleCSAlt = shuffleCS
# vim: set ft=python expandtab :
