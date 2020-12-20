## AES
#############################################

# setwd("/Users/topcue/myR")
rm(list=ls())

# install.packages("digest")

#################### AES ####################
library("digest")

##### key
key <- as.raw(1:16)
aes <- AES(key, mode="ECB")

##### enc num
msg1 <- c(1:16)
raw_msg1 <- as.raw(msg1)
cipher1 <- aes$encrypt(raw_msg1)
dec_raw1 <- aes$decrypt(cipher1, raw=TRUE)
print(dec_raw1)

##### enc text
text_msg1 <- "This is a test!!"
raw_text1 <- charToRaw(text_msg1)
cipher2 <- aes$encrypt(raw_text1)
dec_raw2 <- aes$decrypt(cipher2, raw=TRUE)
dec_text <- rawToChar(dec_raw2)
print(dec_text)

##### Test Vector
hextextToRaw <- function(text) {
	matA <- matrix(
		as.integer(as.hexmode(
			strsplit(text, '')[[1]]
		)), ncol=2, byrow=TRUE
	)
	col_vec <- matA %*% c(16, 1)
	as.raw(col_vec)
}

plaintext <- hextextToRaw("00112233445566778899aabbccddeeff")
aes128key <- hextextToRaw("000102030405060708090a0b0c0d0e0f")
aes128output <- hextextToRaw("69c4e0d86a7b0430d8cdb78070b4c55a")

print(plaintext)

##### use
aes <- AES(aes128key)
aes_cipher <- aes$encrypt(plaintext)
stopifnot(identical(aes128output, aes_cipher))


# EOF
