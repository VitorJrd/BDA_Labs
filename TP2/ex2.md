# Exercice 2

## 1. R(A, B, C) et F = {A → B; B → C}
Par transitivité, étant donné que A → B et B → C: A → C
Nous calculons la fermeture de A: A⁺ = {A, B, C} donc A est la clé candidate.

Nous avons B → C, or B n'est pas une clé donc nous avons une dépendance non clé → dépendance non clé, et donc pas de BCNF.
Décomposons donc selon B → C:
- R1 (B,C)
- R2 (A,B)

Cette forme finale après décomposition est en BCNF

## 2. R(A, B, C) et F = {A → C; A → B}
