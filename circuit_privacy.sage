load('scheme_light.sage')

def randCopoint():
    P = r * TE.random_element()
    Q = sk * P
    while Q.is_zero():
        P = r * TE.random_element()
        Q = sk * P
    return P

def demo_with_full_membership_check(nloop=10):
    for _ in range(nloop):
        c = tuple(randPoint() for _ in range(2))
        assert check(c)
        c0 = rerand(pk, c)
        assert check(c0)
        m = dec(sk, pk, c)
        c1 = enc(pk, m)
        assert check(c1)
        m0 = dec(sk, pk, c0)
        m1 = dec(sk, pk, c1)
        assert m == m0
        assert m == m1
        # Evaluate membership precisely.
        assert (c0[0] in TE) and (c0[1] in TE) and (c1[0] in TE) and (c1[1] in TE)
        assert fullCheck2(c0[0])
        assert fullCheck2(c0[1])
        assert fullCheck2(c1[0])
        assert fullCheck2(c1[1])

def demo_with_light_membership_check(nloop=10):
    for _ in range(nloop):
        c = tuple(randPoint() for _ in range(2))
        g_hat = randCopoint()
        c = (c[0] + g_hat, c[1])
        assert checkAlt(c)
        c0 = rerand(pk, c)
        m = dec(sk, pk, c)
        c1 = enc(pk, m)
        assert checkAlt(c0)
        assert checkAlt(c1)
        m0 = dec(sk, pk, c0)
        m1 = dec(sk, pk, c1)
        assert m == m0
        assert m == m1
        print('Light membership check is done.')
        # Evaluate membership precisely.
        assert (c0[0] in TE) and (c0[1] in TE) and (c1[0] in TE) and (c1[1] in TE)
        assert not fullCheck2(c0[0])
        assert fullCheck2(c0[1])
        assert fullCheck2(c1[0])
        assert not fullCheck2(c1[1])
        print('c0 and c1 do not belong to the same group.')

print(f'Generator: {g}')
print(f'Generated secret-key: {sk}')
print(f'Generated public-key: {pk}')
print('Start demo for circuit privacy with full membership check.')
demo_with_full_membership_check()
print('Start demo for circuit privacy with light membership check.')
demo_with_light_membership_check()
# vim: set ft=python expandtab :
