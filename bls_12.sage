# vim: set ft=python expandtab :

def BLS12():
    QPR.<u> = QQ[]
    pu = (1 / 3) * prod(QPR(x) for x in ([-1, 1], [-1, 1], [1, 0, -1, 0, 1])) + u
    tu = u + 1
    ru = u^4 - u^2 + 1

    h1u = (u - 1)^2 / 3;
    h2u = QPR([13, -4, -4, 6, -4, 0, 5, -4, 1]) / 9
    assert ru.divides(pu^4 - pu^2 + 1)
    hTu = (pu^4 - pu^2 + 1) / ru

    t2u = tu^2 - 2 * pu
    v2u = (u - 1) * (u + 1) * (2 * u^2 - 1) / 3
    tpu = (t2u - 3 * v2u) / 2
    return pu, tu, ru, h1u, h2u, hTu, tpu

u0 = - 2^106 - 2^92 - 2^60 - 2^34 + 2^12 - 2^9

p, t, r, h1, h2, hT, tp = (ZZ(x(u0)) for x in BLS12())

# assert p.is_prime()
# assert r.is_prime()
assert p.is_pseudoprime()
assert r.is_pseudoprime()

assert h2.is_pseudoprime()
assert hT.is_pseudoprime()

assert r.gcd(h1) == 1
assert r.gcd(h2) == 1
assert r.gcd(hT) == 1

Zr = GF(r)
Fp = GF(p)

E = EllipticCurve(Fp, [0, -2])
assert E.order() == p + 1 - t
assert r.divides(p + 1 - t)
assert r * h1 == p + 1 - t

PFp.<ux> = PolynomialRing(Fp)
Fp2.<i> = Fp.extension(ux^2 + 1)
TE = EllipticCurve(Fp2, [0, -2 / (1 + i)])
assert TE.order() == p^2 + 1 - tp, '#TE = {}'.format(TE.order())
assert r.divides(p^2 + 1 - tp)
assert r * h2 == p^2 + 1 - tp

def fullCheck2(P):
    if P.is_zero(): return False
    if not (P[0] in Fp2 and P[1] in Fp2): return False
    if not P in TE: return False
    if (r * P).is_zero():
        return True
    else:
        return False

