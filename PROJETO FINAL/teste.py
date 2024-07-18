import matplotlib.pyplot as plt

# Dados fornecidos
dados = [
    (48, 636.3),
    (48.25, 643.8),
    (49.42, 518.2),
    (49.67, 481),
    (49.83, 480.2),
    (50.1, 472),
    (50.33, 468),
    (50.34, 468)
]

# Separando os dados em listas de x e y
x, y = zip(*dados)

# Criando o gráfico de dispersão
plt.scatter(x, y)
plt.title('COMPRIMENTO DE ONDA X ÂNGULO DE DESVIO MÍNIMO')
plt.legend('DADOS COLETADOS')
plt.xlabel('ÂNGULO DE DESVIO MÍNIMO (graus)')
plt.ylabel('COMPRIMENTO DE ONDA (nm)')

# Exibindo o gráfico
plt.show()

