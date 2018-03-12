import matplotlib.pyplot as plt

def factorial(n):
    if n == 0:
        return 1
    else:
        return n * factorial(n-1)

plt.plot([3,4,5,6,7,8], [178,510,646,1957,5722,8539], 'r--', label='Fewest Stops')
plt.plot([3,4,5,6,7,8], [356,1160,1139,4405,10899,16679], 'g--', label='Fewest Miles')
plt.plot([3,4,5,6,7,8], [factorial(3),factorial(4),factorial(5),factorial(6),factorial(7),factorial(8)], 'b--', label='N!')
plt.plot([3,4,5,6,7,8], [4**3,4**4,4**5,4**6,4**7,4**8], 'y--', label='4^N')
plt.plot([3,4,5,6,7,8], [3**3,3**4,3**5,3**6,3**7,3**8], 'o--', label='3^N')
plt.legend()
plt.xlabel('Number of components per widget(N)')
plt.ylabel('Nodes expanded')
plt.title('Nodes expanded per number of components per widget')
plt.show()
