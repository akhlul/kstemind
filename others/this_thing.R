# don't stem short words
stemmer$stem_word('mei')
stemmer$stem_word('bui')

# lookup up the dictionary, to prevent overstemming
# don't stem nilai to nila
stemmer$stem_word('nilai')

# lah|kah|tah|pun
stemmer$stem_word('hancurlah')
stemmer$stem_word('benarkah')
stemmer$stem_word('apatah')
stemmer$stem_word('siapapun')

# ku|mu|nya
stemmer$stem_word('jubahku')
stemmer$stem_word('bajumu')
stemmer$stem_word('celananya')

# i|kan|an
stemmer$stem_word('hantui')
stemmer$stem_word('sampaikan')
stemmer$stem_word('jualan')

# combination of suffixes
stemmer$stem_word('bukumukah') #gagal karena -ku dianggap suffix dan dihilangkan
stemmer$stem_word('miliknyalah')
stemmer$stem_word('kulitkupun') #gagal karena -ku dianggap suffix dan dihilangkan
stemmer$stem_word('berikanku')
stemmer$stem_word('sakitimu')
stemmer$stem_word('beriannya')
stemmer$stem_word('kasihilah')

# plain prefix
stemmer$stem_word('dibuang')
stemmer$stem_word('kesakitan')
stemmer$stem_word('vokalis')

# stemmer$stem_word('teriakanmu') # wtf? kok jadi ria?
# teriakanmu -> te-ria-kan-mu

# template formulas for derivation prefix rules (disambiguation) #

# rule 1a : berV -> ber-V
stemmer$stem_word('beradu')

# rule 1b : berV -> be-rV
stemmer$stem_word('berambut')

# rule 2 : berCAP -> ber-CAP
stemmer$stem_word('bersuara')

# rule 3 : berCAerV -> ber-CAerV where C != 'r'
stemmer$stem_word('berdaerah')

# rule 4 : belajar -> bel-ajar
stemmer$stem_word('belajar')

# rule 5 : beC1erC2 -> be-C1erC2 where C1 != {'r'|'l'}
stemmer$stem_word('bekerja')
stemmer$stem_word('beternak')

# rule 6a : terV -> ter-V
stemmer$stem_word('terasing')

# rule 6b : terV -> te-rV
stemmer$stem_word('teraup')

# rule 8 : terCerV -> ter-CerV where C != 'r'                        ?ecs
stemmer$stem_word('tergerak')

# rule 7 : terCP -> ter-CP where C != 'r' and P != 'er'
stemmer$stem_word('terpuruk')

# rule 9 : teC1erC2 -> te-C1erC2 where C1 != 'r'
stemmer$stem_word('teterbang')

# rule 10 : me{l|r|w|y}V -> me-{l|r|w|y}V
stemmer$stem_word('melipat')
stemmer$stem_word('meringkas')
stemmer$stem_word('mewarnai')
stemmer$stem_word('meyakinkan')

# rule 11 : mem{b|f|v} -> mem-{b|f|v}
stemmer$stem_word('membangun')
stemmer$stem_word('memfitnah')
stemmer$stem_word('memvonis')

# rule 12 : mempe{r|l} -> mem-pe
stemmer$stem_word('memperbarui')
stemmer$stem_word('mempel')
stemmer$stem_word('mempelajari')           #soemtihg wrong

# rule 13a : mem{rV|V} -> mem{rV|V}
stemmer$stem_word('meminum')

# rule 13b : mem{rV|V} -> me-p{rV|V}
stemmer$stem_word('memukul')

# rule 14 : men{c|d|j|z} -> men-{c|d|j|z}
stemmer$stem_word('mencinta')
stemmer$stem_word('menduakan')
stemmer$stem_word('menjauh')
stemmer$stem_word('menziarah')

# rule 15a : men{V} -> me-n{V}
stemmer$stem_word('menuklir')

# rule 15b : men{V} -> me-t{V}
stemmer$stem_word('menangkap')

# rule 16 : meng{g|h|q} -> meng-{g|h|q}
stemmer$stem_word('menggila')                    #entha napa ada kata 'tggila'
stemmer$stem_word('menghajar')
stemmer$stem_word('mengqasar')

# rule 17a : mengV -> meng-V
stemmer$stem_word('mengudara')

# rule 17b : mengV -> meng-kV
stemmer$stem_word('mengupas')

# rule 18 : menyV -> meny-sV
stemmer$stem_word('menyuarakan')

# rule 19 : mempV -> mem-pV where V != 'e'
stemmer$stem_word('mempopulerkan')

# rule 20 : pe{w|y}V -> pe-{w|y}V
stemmer$stem_word('pewarna')
stemmer$stem_word('peyoga')

# rule 21a : perV -> per-V
stemmer$stem_word('peradilan')

# rule 21b : perV -> pe-rV
stemmer$stem_word('perumahan')

# rule 22 is missing in the document?

# rule 23 : perCAP -> per-CAP where C != 'r' and P != 'er'
stemmer$stem_word('permuka')

# rule 24 : perCAerV -> per-CAerV where C != 'r'
stemmer$stem_word('perdaerah')

# rule 25 : pem{b|f|v} -> pem-{b|f|v}
stemmer$stem_word('pembangun')
stemmer$stem_word('pemfitnah')
stemmer$stem_word('pemvonis')

# rule 26a : pem{rV|V} -> pe-m{rV|V}
stemmer$stem_word('peminum')

# rule 26b : pem{rV|V} -> pe-p{rV|V}       ?ecs
stemmer$stem_word('pemukul')

# rule 27 : men{c|d|j|z} -> men-{c|d|j|z}
stemmer$stem_word('pencinta')
stemmer$stem_word('pendahulu')
stemmer$stem_word('penjarah')
stemmer$stem_word('penziarah')

# rule 28a : pen{V} -> pe-n{V}
stemmer$stem_word('penasihat')

# rule 28b : pen{V} -> pe-t{V}
stemmer$stem_word('penangkap')

# rule 29 : peng{g|h|q} -> peng-{g|h|q}
stemmer$stem_word('penggila')
stemmer$stem_word('penghajar')
stemmer$stem_word('pengqasar')

# rule 30a : pengV -> peng-V
stemmer$stem_word('pengudara')

# rule 30b : pengV -> peng-kV
stemmer$stem_word('pengupas')

# rule 31 : penyV -> peny-sV
stemmer$stem_word('penyuara')

# rule 32 : pelV -> pe-lV except pelajar -> ajar
stemmer$stem_word('pelajar')
stemmer$stem_word('pelabuhan')

# rule 33 : peCerV -> per-erV where C != {r|w|y|l|m|n}
stemmer$stem_word('perserong')

# rule 34 : peCP -> pe-CP where C != {r|w|y|l|m|n} and P != 'er'            ?ecs
stemmer$stem_word('petarung')

# CS additional rules

# rule 35 : terC1erC2 -> ter-C1erC2 where C1 != 'r'
stemmer$stem_word('terpercaya')

# rule 36 : peC1erC2 -> pe-C1erC2 where C1 != {r|w|y|l|m|n}
stemmer$stem_word('pekerja')
stemmer$stem_word('peserta')

# CS modify rule 12
stemmer$stem_word('mempengaruhi')

# CS modify rule 16
stemmer$stem_word('mengkritik')

# CS adjusting rule precedence
stemmer$stem_word('bersekolah') #gagal sekolah -> seko why?
stemmer$stem_word('bertahan')
stemmer$stem_word('mencapai') #gagal mencapai -> capa
stemmer$stem_word('dimulai')
stemmer$stem_word('petani') #gagal petani -> petan          ?ecs jadi stan malah??
stemmer$stem_word('terabai') #gagal terabai -> aba

# ECS
stemmer$stem_word('mensyaratkan')
stemmer$stem_word('mensyukuri')
stemmer$stem_word('mengebom')
stemmer$stem_word('mempromosikan')
stemmer$stem_word('memproteksi')
stemmer$stem_word('memprediksi')
stemmer$stem_word('pengkajian')
stemmer$stem_word('pengebom')

# ECS loop pengembalian akhiran
stemmer$stem_word('bersembunyi')
stemmer$stem_word('bersembunyilah')
stemmer$stem_word('pelanggan')
stemmer$stem_word('pelaku')
stemmer$stem_word('pelangganmukah')
stemmer$stem_word('pelakunyalah')

stemmer$stem_word('perbaikan')
stemmer$stem_word('kebaikannya')
stemmer$stem_word('bisikan')
stemmer$stem_word('menerangi')
stemmer$stem_word('berimanlah')

stemmer$stem_word('memuaskan')
stemmer$stem_word('berpelanggan')
stemmer$stem_word('bermakanan')

