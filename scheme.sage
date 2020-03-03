load("bls_12.sage")

def paramgen():
    f = -TE.defining_polynomial()
    MPR = f.parent()
    f = f(MPR.0, 0, 1).univariate_polynomial()

    # Hard-coded
    x = 1
    t = f(x)
    # if not t.is_squre(): return None
    y = [45647377270319960532999039984803699612977056685366864911629986714044530348093180974053188107880258028396966386077083690032465207351599283862523870225119635222399443602752512296778771121694446,
        49438282901459975659938594364317468186167790685222822704462310333867307155982372418904702082362192518451894435600394942556103437711834606887351852363833749186006882249808988555336582093741501]
    y = Fp2(y)
    assert t == y^2
    P = TE([x, y])
    P = h2 * P
    assert not P.is_zero()
    assert (r * P).is_zero()
    return P

g = paramgen()

def randScalar():
    return randint(1, r - 1)

def randPoint():
    return randScalar() * g

def keygen():
    s = randScalar()
    return s, s * g

def enc(pk, m):
    x = randScalar()
    return x * g, m + x * pk

def check(c, f=fullCheck2):
    if c is None: return None
    return f(c[0]) and f(c[1])

def rerand(pk, c):
    x = randScalar()
    return c[0] + x * g, c[1] + x * pk

def dec(sk, pk, c):
    m = c[1] - sk * c[0]
    return m

def shuffleCS(pk, cs, ns):
    rs = []
    for n in ns:
        c = rerand(pk, cs[n])
        rs.append(c)
    return rs

keypair = keygen()
sk, pk = keypair
# vim: set ft=python expandtab :
