(::)changes
(new), (add), (replace), (remove)

(::)who_modify_rules
NA 		: Nazief Adriani (default)
CS 		: Jelita Asian CS
ECS		: Enhanced CS
MECS	: Modified ECS
AL		: Andi Librarian
CC 		: ?
PA 		: Prasasto Adi
SS 		: Sastrawi

""::rules
C 	: set of consonant letters
A 	: any letters
V 	: set of vocal letters
P 	: a combination of letters

::visitors
DontStemShortWord : "len(word) <= 3"

::suffix_visitors
RemoveInflectionalParticle : "lah|kah|tah|pun"
RemoveInflectionalPossessivePronoun : "ku|mu|nya|-ku|-mu|-nya"
RemoveDerivationalSuffix : "i|kan|an (add sastrawi) is|isme|isasi"

::prefix_pisitors
RemovePlainPrefix : "di|ke|se"
DisambiguatorPrefixRule
.. 1a	: "berV -> ber-V "
.. 1b	: "berV -> be-rV "
.. 2	: "berCAP -> ber-CAP where C != 'r' AND P != 'er'"
.. 3	: "berCAerV -> ber-CAerV where C != 'r'"
.. 4	: "belajar -> bel-ajar"
.. 5	: "beC1erC2 -> be-C1erC2 where C1 != 'r'"
.. 6a	: "terV -> ter-V"
.. 6b	: "terV -> te-rV"
.. 7	: "terCerV -> ter-CerV where C != 'r'"
.. 8	: "terCP -> ter-CP where C != 'r' and P != 'er'"
.. 9	: "te-C1erC2 -> te-C1erC2 where C1 != 'r'"
.. 10	: "me{l|r|w|y}V -> me-{l|r|w|y}V"
.. 11	: "mem{b|f|v} -> mem-{b|f|v}"
.. 12	: "beC1erC2 -> be-C1erC2 where C1 != 'r' (replace CS) mempe -> mem-pe to stem mempengaruhi"
.. 13a	: "mem{rV|V} -> me-m{rV|V}"
.. 13b	: "mem{rV|V} -> me-p{rV|V}"
.. 14	: "men{c|d|j|z} -> men-{c|d|j|z} (replace ECS) men{c|d|j|s|z} -> men-{c|d|j|s|z} (replace AL) men{c|d|j|s|t|z} -> men-{c|d|j|s|t|z}"
.. 15a	: "men{V} -> me-n{V}"
.. 15b	: "men{V} -> me-t{V}"
.. 16	: "meng{g|h|q} -> meng-{g|h|q}"
.. 17a	: "mengV -> meng-V"
.. 17b	: "mengV -> meng-kV"
.. 17c	: "mengV -> meng-V- where V = 'e'"
.. 17d	: "mengV -> me-ngV"
.. 18a	: "menyV -> me-nyV to stem menyala -> nyala"
.. 18b	: "menyV -> meny-sV"
.. 19	: "mempV -> mem-pV where V != 'e' (replace ECS) mempA -> mem-pA where A != 'e' in order to stem memproteksi"
.. 20	: "pe{w|y}V -> pe-{w|y}V"
.. 21a	: "perV -> per-V"
.. 21b	: "perV -> pe-rV"
.. 23	: "perCAP -> per-CAP where C != 'r' AND P != 'er'"
.. 24	: "perCAerV -> per-CAerV where C != 'r'"
.. 25	: "pem{b|f|v} -> pem-{b|f|v}"
.. 26a	: "pem{rV|V} -> pe-m{rV|V}"
.. 26b	: "pem{rV|V} -> pe-p{rV|V}"
.. 27	: "pen{c|d|j|z} -> pen-{c|d|j|z} (replace PA) pen{c|d|j|s|t|z} -> pen-{c|d|j|s|t|z}"
.. 28a	: "pen{V} -> pe-n{V}"
.. 28b	: "pen{V} -> pe-t{V}"
.. 29	: "peng{g|h|q} -> peng-{g|h|q} (replace ECS) pengC -> peng-C"
.. 30a	: "pengV -> peng-V"
.. 30b	: "pengV -> peng-kV"
.. 30c	: "pengV -> pengV- where V = 'e'"
.. 31a	: "penyV -> pe-nyV"
.. 31b	: "penyV -> peny-sV"
.. 32	: "pelV -> pe-lV except pelajar -> ajar"
.. 34	: "peCP -> pe-CP where C != {r|w|y|l|m|n} and P != 'er'"
.. 35	: "(new CS) terC1erC2 -> ter-C1erC2 where C1 != {r}"
.. 36	: "(new CS) peC1erC2 -> pe-C1erC2 where C1 != {r|w|y|l|m|n}"
.. 37a	: "(new CS) CerV -> CerV"
.. 37b	: "(new CS) CerV -> CV"
.. 38a	: "(new CS) CelV -> CelV"
.. 38b	: "(new CS) CelV -> CV"
.. 39a	: "(new CS) CemV -> CemV"
.. 39b	: "(new CS) CemV -> CV"
.. 40a	: "(new CS) CinV -> CinV"
.. 40b	: "(new CS) CinV -> CV"
.. 41	: "(new SS) kuA -> ku-A"
.. 42	: "(new SS) kauA -> kau-A"


