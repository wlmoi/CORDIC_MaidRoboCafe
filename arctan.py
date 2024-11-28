import math

iterasi = 15

def find_arctan(x):
    return math.atan(x) 

tabel = [[0 for i in range(3)] for j in range(iterasi)]

for i in range(iterasi) :
    x = 1/(2**(i))
    y = math.degrees(find_arctan(x))
    tabel[i] = [i,y,x]

# input
a = 1 # koorinat x
b = 2      # koordinat y

x = 1
y = 0   

theta = 0

for i in range(iterasi) :
    if y/x < b/a  :
        new_x = x - y*(1/2**(i))
        new_y = y + x*(1/2**(i))
    
        theta += tabel[i][1]
    
    else :
        new_x = x + y*(1/2**(i))
        new_y = y - x*(1/2**(i))

        theta -= tabel[i][1]
    
    x = new_x
    y = new_y

# print(f'actan cordic = {theta}, nilai asli = {math.degrees(math.atan(b/a))}')
for i in tabel:
    print(i)


