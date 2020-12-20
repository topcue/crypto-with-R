## DH
## DH Sodium
#############################################

# setwd("/Users/topcue/myR")
rm(list=ls())


# install.packages("openssl")
# install.packages("sodium")

#################### DH ####################
rm(list=ls())
library(openssl)

p <- 907
g <- 490
a <- 98

# ERROR!
ga <- g^a %% p 

# ga <- g^a [p]
ga <- bignum_mod_exp(bignum(g), bignum(a), bignum(p))
print(ga)

# (0) Prepare public parameters (p, g)
p <- 907	# 2048 bit prime number (Miller-Rabin Algorithm)
g <- 490	# generator

# (1) Alice : Generate random secret
a <- 98

# (2) Alice : Compute g^a [mod p]
ga <- bignum_mod_exp(bignum(g), bignum(a), bignum(p))

# (3) Alice : Send ga to Bob
# (Alice) -----> ga ----> (Bob)

# (4) Bob : Generate random secret b
b <- 127

# (5) Bob : Compute g^b [mod p]
gb <- bignum_mod_exp(bignum(g), bignum(b), bignum(p))

# (6) Bob : Send gb to Alice
# (Bob) ----> gb ----> (Alice)
# Alice : a, gb
# Bob   : b, ga

# (7) Alice : Compute Ka = (gb)^a [p]
Ka <- bignum_mod_exp(bignum(gb), bignum(a), bignum(p))

# (8) Bob   : Compute Kb = (ga)^b [p]
Kb <- bignum_mod_exp(bignum(ga), bignum(b), bignum(p))

print(Ka == Kb)

#################### DH Sodium ####################
rm(list=ls())
library(sodium)

# Alice
alice_key <- keygen() # a
alice_pubkey <- pubkey(alice_key) # g^a

# Bob
bob_key <- keygen() # b
bob_pubkey <- pubkey(bob_key) # g^a

# Alice alice_secret = (g^b)^as
alice_secret <- diffie_hellman(alice_key, bob_pubkey)

# Bob : bob_secret = (g^a)^b
bob_secret <- diffie_hellman(bob_key, alice_pubkey)

print(alice_secret == bob_secret)


# EOF

