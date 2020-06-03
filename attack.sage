import random

load("scheme_light.sage")

def distinctRandCopoint(n):
    rs = set([])
    while len(rs) < n:
        P = r * TE.random_element()
        rs.add(P)
    return rs

def randPermutation(l):
    s = list(range(l))
    random.shuffle(s)
    return tuple(s)

def encOracle(m):
    return enc(pk, m)

def demo(l, nloop=10):
    for _ in range(nloop):
        sigma = randPermutation(l)
        print('Permutation sigma   = {}'.format(sigma))

        print('Begin 𝓐(find, l):')
        hs = distinctRandCopoint(l)
        assert all((h2 * h).is_zero() for h in hs)
        ms = [randPoint() for _ in range(l)]
        assert all((r * m).is_zero() for m in ms)
        print('𝓐 accesses to the encryption oracle.')
        cs = [encOracle(m) for m in ms]
        assert all((r * c[0]).is_zero() and (r * c[1]).is_zero() for c in cs)
        c1s = [c[0] for c in cs]
        print('𝓐 exploits malleability.')
        c1s = [h + c for h,c in zip(hs, c1s)]
        cs = [(c1, c[1]) for c1,c in zip(c1s, cs)]
        print('End 𝓐(find, l).')

        print('Check membership.')
        assert all(checkAlt(c) for c in cs)
        print('Shuffle ciphertext vector.')
        cs2 = shuffleCSAlt(pk, cs, sigma)
        assert len(cs) == len(cs2)
        # With very high probability:
        assert all(not lcs == rcs for lcs,rcs in zip(cs, cs2))

        print('Begin 𝓐(guess, v\'):')
        hrs = [r * h for h in hs]
        assert all(not h.is_zero() for h in hrs)
        cs2r = [(r * c2[0]) for c2 in cs2]
        print('𝓐 uses malleability.')
        sigma_hat = tuple([hrs.index(c1r) for c1r in cs2r])
        print('End 𝓐(guess, v\').')
        print('Extracted sigma hat = {}'.format(sigma_hat))
        assert sigma == sigma_hat
        print('Permutation extraction is succeeded so that permutation is not hidden.')
        print('')

print(f'Generator: {g}')
print(f'Generated secret-key: {sk}')
print(f'Generated public-key: {pk}')
_len_vec = 5
_nloop = 10
print(f'Start demo for permutation of degree-{_len_vec} repeatedly {_nloop} times.')
demo(_len_vec, _nloop)
# vim: set ft=python expandtab :
