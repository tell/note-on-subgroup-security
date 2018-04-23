# vim: set ft=python expandtab :

load("scheme.sage")

test_nloop = 10

def lightCheck2(P):
    if P.is_zero(): return False
    if not (P[0] in Fp2 and P[1] in Fp2): return False
    if not P in TE: return False
    return True

def checkAlt(c): return check(c, lightCheck2)
def rerandAlt(pk, c): return rerand(pk, c, lightCheck2)
def decAlt(sk, pk, c): return dec(sk, pk, c)
def shuffleCSAlt(pk, cs, ns): return shuffleCS(pk, cs, ns, rerandAlt)

assert all(checkAlt(enc(pk, m)) for m in (randPoint() for _ in range(test_nloop)))
assert all(decAlt(sk, pk, enc(pk, m)) == m for m in (randPoint() for _ in range(test_nloop)))
assert all(decAlt(sk, pk, c) == decAlt(sk, pk, rerandAlt(pk, c)) for c in (enc(pk, randPoint()) for _ in range(test_nloop)))

assert all(checkAlt(enc(pk, m)) for m in (TE.random_element() for _ in range(test_nloop)))
assert all(decAlt(sk, pk, enc(pk, m)) == m for m in (TE.random_element() for _ in range(test_nloop)))
assert all(decAlt(sk, pk, c) == decAlt(sk, pk, rerandAlt(pk, c)) for c in (enc(pk, TE.random_element()) for _ in range(test_nloop)))

assert not all(check(enc(pk, m)) for m in (TE.random_element() for _ in range(test_nloop)))
# assert all(dec(sk, pk, enc(pk, m)) == m for m in (TE.random_element() for _ in range(test_nloop)))
for m in (TE.random_element() for _ in range(test_nloop)):
    c = enc(pk, m)
    cc = rerand(pk, c)
    if cc is None: continue
    assert dec(sk, pk, c) == dec(sk, pk, cc)

def distinctRandCopoint(n):
    rs = set([])
    while len(rs) < n:
        P = r * TE.random_element()
        rs.add(P)
    return rs

def randPermutation(l):
    s = range(l)
    shuffle(s)
    return tuple(s)

def encOracle(m):
    return enc(pk, m)

def demo(l, nloop=10):
    for _ in range(nloop):
        print('Begin A(find, l):')
        hs = distinctRandCopoint(l)
        assert all((h2 * h).is_zero() for h in hs)
        ms = [randPoint() for _ in range(l)]
        assert all((r * m).is_zero() for m in ms)
        cs = [encOracle(m) for m in ms]
        assert all((r * c[0]).is_zero() and (r * c[1]).is_zero() for c in cs)
        c1s = [c[0] for c in cs]
        c1s = [h + c for h,c in zip(hs, c1s)]
        cs = [(c1, c[1]) for c1,c in zip(c1s, cs)]
        assert all(checkAlt(c) for c in cs)
        print('End A(find, l).')

        sigma = randPermutation(l)
        print('Permutation sigma   = {}'.format(sigma))
        cs2 = shuffleCSAlt(pk, cs, sigma)
        assert all(checkAlt(c) for c in cs)
        assert len(cs) == len(cs2)
        assert all(not lcs == rcs for lcs,rcs in zip(cs, cs2))

        print('Begin A(guess, v, v\'):')
        hrs = [r * h for h in hs]
        assert all(not h.is_zero() for h in hrs)
        cs2r = [(r * c2[0]) for c2 in cs2]
        sigma_hat = tuple([hrs.index(c1r) for c1r in cs2r])
        print('End A(guess, v, v\').')
        print('Extracted sigma hat = {}'.format(sigma_hat))
        assert sigma == sigma_hat
        print('Permutation extraction is succeeded.')
        print('')

print('Start demo...')
demo(4)
