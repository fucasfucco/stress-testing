import redis

r = redis.Redis(host='localhost', port=6379, db=0)

busca = ['adidas', 'blusa', 'bolsa', 'saia']
r.rpush('busca', *busca)

categorias = [
    'basicos/masculino/bermudas',
    'jeans/feminino/calca-jeans',
    'eletronicos/audio-e-video/caixa-de-som-e-dock-station',
    'moda-casa/banho/jogo-de-toalhas'
]
r.rpush('categorias', *categorias)

produtos = [
    'capa-protetora-para-travesseiro-tnt-casa-riachuelo-branco-50x70cm-11017236001_sku;11017236001;RCHLO;capa-protetora-para-travesseiro-tnt-casa-riachuelo-branco-50x70cm-11017236001_sku;15472094',
    'masc-super-hidratante-lola-morte-subita-11531827001_sku;11531827001;RCHLO;masc-super-hidratante-lola-morte-subita-11531827001_sku;15101568',
    'kit-meia-esportiva-cano-invisivel-10464492002_sku_branco;10464492002;RCHLO;kit-meia-esportiva-cano-invisivel-10464492002_sku_branco;14935007',
    'bone-infantil-sonic-azul-13549146002_sku;13549146001;RCHLO;bone-infantil-sonic-azul-13549146002_sku;12292621'
]
r.rpush('produtos', *produtos)
