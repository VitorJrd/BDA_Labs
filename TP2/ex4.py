# Exercice 4
import itertools

# Nous prenons les relations et les dépendances fonctionnelles utilisées dans le sujet
myrelations = [{'A', 'B', 'C', 'G', 'H', 'I'}, {'X', 'Y'}]

mydependencies = [({'A'}, {'B'}), ({'A'}, {'C'}), ({'C', 'G'}, {'H'}), ({'C', 'G'}, {'I'}), ({'B'}, {'H'})]

#Afficher les dépendances
def printDependencies(F):
    for alpha, beta in F:
        print(alpha, "->", beta)


#Afficher les relations
def printRelations(T):
    for R in T:
        print(R)


#Ensemble des sous-ensembles
def powerSet(inputset):
    result = []
    for r in range(1, len(inputset) + 1):
        result += list(map(set, itertools.combinations(inputset, r)))
    return result


#Fermeture d’un ensemble d’attributs
def closure(F, K):
    result = set(K)

    changed = True
    while changed:
        changed = False
        for alpha, beta in F:
            if alpha.issubset(result):
                if not beta.issubset(result):
                    result |= beta
                    changed = True

    return result


#Vérifier si alpha → beta
def implies(F, alpha, beta):
    return beta.issubset(closure(F, alpha))


#Vérifier si K est une super-clé
def isSuperKey(F, R, K):
    return closure(F, K) == R


# Vérifier si K est une clé candidate
def isCandidateKey(F, R, K):
    if not isSuperKey(F, R, K):
        return False

    #Minimalité
    for subset in powerSet(K):
        if subset != K and isSuperKey(F, R, subset):
            return False

    return True


#Trouver toutes les super-clés
def allSuperKeys(F, R):
    keys = []
    for subset in powerSet(R):
        if isSuperKey(F, R, subset):
            keys.append(subset)
    return keys


#Trouver toutes les clés candidates
def allCandidateKeys(F, R):
    keys = []
    for subset in powerSet(R):
        if isCandidateKey(F, R, subset):
            keys.append(subset)
    return keys


#Vérifier BCNF pour une relation
def isBCNF(F, R):
    for alpha, beta in F:
        if alpha.issubset(R):
            if not isSuperKey(F, R, alpha):
                return False
    return True


# Tests
R = {'A', 'B', 'C', 'D', 'E'}

print(closure(mydependencies, {'A'}))    #doit produire {'A', 'B', 'C', 'H'}
print(allCandidateKeys(mydependencies, R))    #doit produire []
print(isBCNF(mydependencies, R))    #doit produire false
