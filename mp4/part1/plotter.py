import matplotlib.pyplot as plt

f = open('data.txt', 'r')

i = 0

games = []
scores = []
means = []
for line in f:
    if i <= 400:
        games.append(int(line))
    elif i != '' and i < 803 and i > 401:
        means.append(float(line.replace('\n', '').replace('\r', '')))
    elif line != '' and i > 803 and i < 1205:
        scores.append(int(line))

    i += 1

plt.subplot(211)
plt.plot(games, scores, 'g', label='Scores')
plt.axvline(x=200, color='r', label='Testing')
plt.legend()
plt.subplot(212)
plt.plot(games, means, 'g', label='Per Episode Mean Reward')
plt.axvline(x=200, color='r', label='Testing')
plt.legend()
# plt.xlabel('Number of components per widget(N)')
# plt.ylabel('Nodes expanded')
# plt.title('Nodes expanded per number of components per widget')
plt.show()
