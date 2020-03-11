load('scheme_light.sage')

def test_scheme_light(num_check=5):
    print(f'Generated secret-key: {sk}')
    print(f'Generated public-key: {pk}')
    assert all(checkAlt(enc(pk, m)) for m in (randPoint() for _ in range(num_check)))
    assert all(decAlt(sk, pk, enc(pk, m)) == m for m in (randPoint() for _ in range(num_check)))
    assert all(decAlt(sk, pk, c) == decAlt(sk, pk, rerandAlt(pk, c)) for c in (enc(pk, randPoint()) for _ in range(num_check)))

    assert all(checkAlt(enc(pk, m)) for m in (TE.random_element() for _ in range(num_check)))
    assert all(decAlt(sk, pk, enc(pk, m)) == m for m in (TE.random_element() for _ in range(num_check)))
    assert all(decAlt(sk, pk, c) == decAlt(sk, pk, rerandAlt(pk, c)) for c in (enc(pk, TE.random_element()) for _ in range(num_check)))

    assert not all(check(enc(pk, m)) for m in (TE.random_element() for _ in range(num_check)))
    assert all(dec(sk, pk, enc(pk, m)) == m for m in (TE.random_element() for _ in range(num_check)))
    for m in (TE.random_element() for _ in range(num_check)):
        c = enc(pk, m)
        cc = rerand(pk, c)
        if cc is None: continue
        assert dec(sk, pk, c) == dec(sk, pk, cc)

print(f'Start tests by {__file__}')
test_scheme_light()
print('Finished.')
# vim: set ft=python expandtab :
