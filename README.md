# PSRIO.jl

[build-img]: https://github.com/psrenergy/PSRIO.jl/workflows/CI/badge.svg?branch=master
[build-url]: https://github.com/psrenergy/PSRIO.jl/actions?query=workflow%3ACI

| **Build Status** |
|:-----------------:|
| [![Build Status][build-img]][build-url] |

Interface Julia para o PSRIO.

Para adicionar o PSRIO
```julia
add https://github.com/psrenergy/PSRIO.jl.git
```

A forma recomendada usar a biblioteca colocar os comandos abaixo no início do projeto
```julia
using PSRIO
psrio = PSRIO.create()
```

Caso deseje rodar com uma distribuição do PSRIO diferente da padrão distribuída pelo pacote é sugerido que se use o comando
```julia
psrio = PSRIO.create(; path = "path para a pasta com a distribuição")
```

Uma vez que o ponteiro tenha sido devidamente criado a forma recomendada para se usar os scripts é criar um script em um `arquivo.lua` e rodar o comando
```julia
PSRIO.run(psrio, "path do caso"; model = "none", recipes = ["path para arquivo.lua"])
```

Caso deseje rodar o PSRIO com multiplos casos basta apenas passar um vetor de casos:
```julia
PSRIO.run(psrio, ["path do caso 1", "path do caso 2", "path do caso 3"]; model = "none", recipes = ["path para arquivo.lua"])
```

Se a função `PSRIO.run` retornar um `IOError` com mensagens de "permission denied" tente rodar o comando `PSRIO.set_executable_chmod(0o755)` e rodar de novo o `PSRIO.run`

Para mais informações sobre como fazer os scripts visite a [documentação](https://psrio.psr-inc.com/index.html)
