x = 1000000

def root(n,m) :
    return 0.5*(m + n/m)

temp = x // 2
print(root(x,temp))

for i in range(10) :
    temp = root(x,temp)



print(f'The square root of {x} is {temp}, while the true value is {x**0.5}')
