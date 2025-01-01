x = 0.001


def bit(m) :
    r = ''
    for i in range(10) :
        m = m * 2

        if m >= 1 :
            r += '1'
            m -= 1
        
        else :
            r += '0'
    return r
    
for i in range(50) :
    print(f"{x:.3f}", bit(x))
    x += 0.001

# print(f"{x:.3f}", bit(x))