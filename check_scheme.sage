load('scheme.sage')

def test_scheme(num_check=5):
    print(f'Generated secret-key: {sk}')
    print(f'Generated public-key: {pk}')
    assert all(check(enc(pk, m)) for m in (randPoint() for _ in range(num_check)))
    assert all(dec(sk, pk, enc(pk, m)) == m for m in (randPoint() for _ in range(num_check)))
    assert all(dec(sk, pk, c) == dec(sk, pk, rerand(pk, c)) for c in (enc(pk, randPoint()) for _ in range(num_check)))

print(f'Start tests by {__file__}')
test_scheme(10)
print('Finished.')
# vim: set ft=python expandtab :
