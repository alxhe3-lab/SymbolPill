# SymbolPill

Les symboles scientifiques qu'on ne trouve pas sur le clavier, à un clic, dans la barre des menus de macOS : lettres grecques, flèches, ≤ ≥ ± ≈, exposants et indices (×10⁻³, x², Ca²⁺, HCO₃⁻), symboles médicaux… Pensé pour un étudiant en médecine qui prend ses notes sur ordinateur.

*Scientific symbols you can't type, one click away in the macOS menu bar: Greek letters, arrows, superscripts and subscripts, ions, medical signs. Built for med students taking notes on a Mac. One Swift file.*

## Ce qu'elle fait

- Icône dans la barre des menus ; une grille de symboles classés par section.
- **Recherche** par nom, mot-clé ou symbole : « delta », « somme », « micro », « ca2+ » ou « hco3- » trouvent le bon signe.
- Puissances de dix toutes prêtes (×10⁻¹² à ×10⁹), avec le préfixe du système international dans les mots-clés (pico, nano, micro, milli…).
- La rangée du haut garde tes derniers symboles.
- **Clavier** : flèches pour se déplacer, **Entrée** pour copier, **Tab** pour changer de section, **Échap** pour effacer la recherche puis fermer.
- Les signes qui s'affichent d'habitude en emoji couleur (♂ ♀ ⚠…) sont copiés en version texte.
- Option « Ouvrir à l'ouverture de session ». Thème clair et sombre.

Le catalogue est en haut de `SymbolPill.swift` (une ligne par symbole : `"symbole|nom|mots-clés"`) : facile à adapter à ta matière.

## Installer

Il faut macOS 13 ou plus récent et les outils de ligne de commande de Xcode (`xcode-select --install`).

```bash
git clone https://github.com/alxhe3-lab/SymbolPill.git
cd SymbolPill
./build.sh
```

`build.sh` compile l'app, la signe localement, l'installe dans `/Applications` (ou `~/Applications`) et la lance.

## Licence

MIT.
