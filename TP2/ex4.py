# Exercice 4
import itertools

# Nous prenons les relations et les dépendances fonctionnelles utilisées dans le sujet
myrelations = [{'A', 'B', 'C', 'G', 'H', 'I'}, {'X', 'Y'}]

mydependencies = [
    ({'A'}, {'B'}),
    ({'A'}, {'C'}),
    ({'C', 'G'}, {'H'}),
    ({'C', 'G'}, {'I'}),
    ({'B'}, {'H'})
]

# Afficher les dépendances
def printDependencies(F):
    for alpha, beta in F:
        print(alpha, "->", beta)


# Afficher les relations
def printRelations(T):
    for R in T:
        print(R)


# Ensemble des sous-ensembles
def powerSet(inputset):
    result = []
    elements = list(inputset)
    for r in range(1, len(elements) + 1):
        result += list(map(set, itertools.combinations(elements, r)))
    return result


#Fermeture d’un ensemble d’attributs
def closure(F, K):
    result = set(K)

    changed = True
    while changed:
        changed = False
        for alpha, beta in F:
            if alpha.issubset(result) and not beta.issubset(result):
                result |= beta
                changed = True

    return result


#Clôture de F
# On retourne toutes les dépendances alpha -> beta que l’on peut déduire
# à partir des attributs présents dans F
def closureOfF(F):
    all_attributes = set()

    for alpha, beta in F:
        all_attributes |= alpha
        all_attributes |= beta

    result = []

    for alpha in powerSet(all_attributes):
        alpha_closure = closure(F, alpha)

        for beta in powerSet(all_attributes):
            if beta.issubset(alpha_closure):
                result.append((alpha, beta))

    return result


#Vérifier si alpha -> beta
def implies(F, alpha, beta):
    return beta.issubset(closure(F, alpha))


# Vérifier si K est une super-clé
def isSuperKey(F, R, K):
    return R.issubset(closure(F, K))


# Vérifier si K est une clé candidate
def isCandidateKey(F, R, K):
    if not isSuperKey(F, R, K):
        return False

    # Minimalité
    for subset in powerSet(K):
        if subset != K and isSuperKey(F, R, subset):
            return False

    return True


# Trouver toutes les clés candidates
def allCandidateKeys(F, R):
    keys = []
    for subset in powerSet(R):
        if isCandidateKey(F, R, subset):
            keys.append(subset)
    return keys


# Trouver toutes les super-clés
def allSuperKeys(F, R):
    keys = []
    for subset in powerSet(R):
        if isSuperKey(F, R, subset):
            keys.append(subset)
    return keys


#Retourner une clé candidate
def oneCandidateKey(F, R):
    keys = allCandidateKeys(F, R)
    if len(keys) > 0:
        return keys[0]
    return None


# Projection simple des dépendances sur une relation R
# On garde uniquement les dépendances dont les attributs sont dans R
def projectDependencies(F, R):
    projected = []

    for alpha, beta in closureOfF(F):
        if alpha.issubset(R) and beta.issubset(R) and len(beta) > 0:
            projected.append((alpha, beta))

    return projected


# Vérifier BCNF pour une relation
def isBCNF(F, R):
    projectedF = projectDependencies(F, R)

    for alpha, beta in projectedF:
        # on ignore les dépendances triviales
        if beta.issubset(alpha):
            continue

        if not isSuperKey(F, R, alpha):
            return False

    return True


# Vérifier si un schéma est en BCNF
def areAllRelationsBCNF(F, T):
    for R in T:
        if not isBCNF(F, R):
            return False
    return True


# Chercher une dépendance qui viole la BCNF dans R
def findBCNFViolation(F, R):
    projectedF = projectDependencies(F, R)

    for alpha, beta in projectedF:
        if beta.issubset(alpha):
            continue

        if not isSuperKey(F, R, alpha):
            return (alpha, beta)

    return None


# Décomposition en BCNF
def bcnfDecomposition(F, T):
    result = list(T)
    changed = True

    while changed:
        changed = False
        new_result = []

        for R in result:
            violation = findBCNFViolation(F, R)

            if violation is None:
                new_result.append(R)
            else:
                alpha, beta = violation

                # Décomposition classique:
                # R1 = alpha U beta
                # R2 = R - (beta - alpha)
                R1 = alpha | beta
                R2 = R - (beta - alpha)

                new_result.append(R1)
                new_result.append(R2)
                changed = True

        result = new_result

    return result


# Tests
R = {'A', 'B', 'C', 'D', 'E'}

print("Fermeture de {A} :")
print(closure(mydependencies, {'A'}))   #doit produire {'A', 'B', 'C', 'H'}

print("\nToutes les clés candidates de R :")
print(allCandidateKeys(mydependencies, R))   #doit produire []

print("\nR est-il en BCNF ?")
print(isBCNF(mydependencies, R))   #doit produire False

print("\nUne clé candidate de R :")
print(oneCandidateKey(mydependencies, R))   #doit produire None

print("\nLe schéma myrelations est-il en BCNF ?")
print(areAllRelationsBCNF(mydependencies, myrelations))

print("\nDécomposition BCNF de myrelations :")
print(bcnfDecomposition(mydependencies, myrelations))
