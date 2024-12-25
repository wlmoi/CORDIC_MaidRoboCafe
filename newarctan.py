import math

iterasi = 70

def find_arctan(x):
    return math.atan(x) 

tabel = [[0 for i in range(3)] for j in range(iterasi)]

for i in range(iterasi) :
    x = 1/(2**(i))
    y = math.degrees(find_arctan(x))
    tabel[i] = [i,y,x]

# input
x = 3
y = 4   

theta = 0

for i in range(iterasi) :
    if y < 0  :
        new_x = x - y*(1/2**(i))
        new_y = y + x*(1/2**(i))
        
    
        theta -= tabel[i][1]
    
    else :
        new_x = x + y*(1/2**(i))
        new_y = y - x*(1/2**(i))
 
        theta += tabel[i][1]
    
    
    
    x = new_x
    y = new_y
    # print(f'iterasi ke-{i+1} theta = {theta}, y = {y} , x = {x}')

print(f'actan cordic = {theta}, nilai asli = {math.degrees(math.atan(b/a))} y: {y}, x: {x}')

print((a**2 + b**2)**0.5)
print(y)
print(x)
