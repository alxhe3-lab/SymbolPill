import SwiftUI
import AppKit
import ServiceManagement

// MARK: - Catalogue
// Chaque entrée : "symbole|nom affiché|mots-clés de recherche".

struct Sym: Identifiable, Hashable {
    let value: String, name: String, keywords: String
    var id: String { value }
    init(_ raw: String) {
        let p = raw.components(separatedBy: "|")
        value = p[0]
        name = p.count > 1 ? p[1] : p[0]
        keywords = p.count > 2 ? p[2] : ""
    }
}

struct Group: Identifiable {
    let id: String, columns: Int, items: [Sym]
}

struct Section: Identifiable {
    let id: String, label: String, title: String, groups: [Group]
}

func syms(_ raws: [String]) -> [Sym] { raws.map(Sym.init) }

// Règle du catalogue (1re année) : ce qui revient dans les cours ET qui ne se tape pas au clavier.
// mmHg, kDa ou ATP n'y sont donc pas : ils s'écrivent directement.

let greek = syms([
    "α|alpha", "β|bêta|beta", "γ|gamma", "δ|delta", "ε|epsilon", "ζ|zêta|zeta", "η|êta|eta viscosite", "θ|thêta|theta",
    "ι|iota", "κ|kappa", "λ|lambda|longueur d'onde", "μ|mu (lettre grecque)|mu", "ν|nu|frequence", "ξ|xi", "π|pi", "ρ|rhô|rho masse volumique",
    "σ|sigma", "τ|tau", "υ|upsilon", "φ|phi", "χ|khi|chi", "ψ|psi", "ω|oméga|omega",
    "Γ|Gamma majuscule", "Δ|Delta majuscule|variation difference", "Θ|Thêta majuscule|theta", "Λ|Lambda majuscule",
    "Ξ|Xi majuscule", "Π|Pi majuscule", "Σ|Sigma majuscule|somme", "Φ|Phi majuscule|flux", "Ψ|Psi majuscule", "Ω|Oméga majuscule|omega ohm",
])

let superscriptDigits = Array("⁰¹²³⁴⁵⁶⁷⁸⁹")
func superscript(_ n: Int) -> String {
    (n < 0 ? "⁻" : "") + String(abs(n)).map { String(superscriptDigits[$0.wholeNumberValue!]) }.joined()
}
let prefixes = [-12: "pico", -9: "nano", -6: "micro", -3: "milli", -2: "centi", -1: "déci", 3: "kilo", 6: "méga", 9: "giga", 12: "téra"]

/// « ×10⁻³ », avec le préfixe du système international dans les mots-clés.
func power(_ n: Int) -> Sym {
    let sign = n < 0 ? "−" : ""
    let unit = prefixes[n].map { " (\($0))" } ?? ""
    return Sym("×10\(superscript(n))|× 10 puissance \(sign)\(abs(n))\(unit) · ⌥ clic : sans le ×|puissance \(prefixes[n] ?? "")")
}
let negativePowers = ([-1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -12, -14, -19, -23, -27]).map(power)
let positivePowers = ([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 14, 18, 23, 27]).map(power)

let arrows = syms([
    "→|flèche droite|donne entraine vers fleche", "←|flèche gauche|fleche", "↑|flèche haut|augmentation hausse fleche", "↓|flèche bas|diminution baisse fleche",
    "↔|flèche double|echange fleche", "⇌|équilibre réversible|equilibre reaction fleche", "⇄|flèches opposées|echange reversible fleche", "⇒|implique|entraine donc fleche",
    "⇔|équivaut à|equivalence fleche", "↗|augmente|hausse fleche", "↘|diminue|baisse fleche", "↑↑|forte augmentation|hausse fleche",
    "↓↓|forte diminution|baisse fleche", "↪|flèche à crochet|renvoi fleche", "⟶|flèche longue|reaction fleche", "↕|flèche verticale double|fleche",
])

let signs = syms([
    "×|multiplié par|fois", "−|moins (vrai signe)|minus soustraction", "·|point médian|produit", "÷|divisé par", "≈|environ|approximativement", "≠|différent de|different", "≤|inférieur ou égal|inf", "≥|supérieur ou égal|sup",
    "±|plus ou moins", "≪|très inférieur à", "≫|très supérieur à", "∝|proportionnel à", "√|racine carrée", "∞|infini", "∫|intégrale", "∑|somme",
    "½|un demi", "⅓|un tiers", "¼|un quart", "¾|trois quarts", "‰|pour mille", "°|degré|degre", "′|prime (5′, 3′)|minute", "″|double prime|seconde",
    "µ|micro (µm, µg, µmol)|micro", "∈|appartient à", "∂|dérivée partielle|derivee", "✓|coche|oui correct", "✗|croix|non faux", "⚠|attention|piege",
])

let powers = syms([
    "⁰|exposant 0", "¹|exposant 1", "²|exposant 2|carre", "³|exposant 3|cube", "⁴|exposant 4", "⁵|exposant 5", "⁶|exposant 6", "⁷|exposant 7",
    "⁸|exposant 8", "⁹|exposant 9", "⁺|exposant plus|charge positive", "⁻|exposant moins|charge negative", "ⁿ|exposant n",
])

let indices = syms([
    "₀|indice 0", "₁|indice 1", "₂|indice 2", "₃|indice 3", "₄|indice 4", "₅|indice 5", "₆|indice 6", "₇|indice 7",
    "₈|indice 8", "₉|indice 9", "₊|indice plus", "₋|indice moins", "ₙ|indice n", "ₐ|indice a", "ₘ|indice m", "ₓ|indice x",
])

let chemistry = syms([
    "Na⁺|ion sodium|natremie", "K⁺|ion potassium|kaliemie", "H⁺|proton|hydrogene ion", "Ca²⁺|ion calcium|calcemie", "Cl⁻|ion chlorure|chloremie",
    "Mg²⁺|ion magnésium", "Fe²⁺|fer ferreux", "Fe³⁺|fer ferrique", "Zn²⁺|ion zinc", "I⁻|ion iodure",
    "HCO₃⁻|bicarbonate", "OH⁻|ion hydroxyde", "NH₄⁺|ammonium", "H₃O⁺|ion oxonium|hydronium", "H₂PO₄⁻|dihydrogénophosphate|phosphate",
    "HPO₄²⁻|hydrogénophosphate|phosphate", "PO₄³⁻|phosphate", "SO₄²⁻|sulfate", "CO₃²⁻|carbonate", "Cu²⁺|ion cuivre",
    "O₂|dioxygène|oxygene", "CO₂|dioxyde de carbone|gaz carbonique", "H₂O|eau", "H₂O₂|eau oxygénée|peroxyde", "N₂|diazote|azote",
    "NH₂|groupe amine", "NH₃|ammoniac", "CH₃|groupe méthyle|methyl", "H₂CO₃|acide carbonique", "C₆H₁₂O₆|glucose",
    "PO₂|pression partielle d'O₂", "PCO₂|pression partielle de CO₂", "HbO₂|oxyhémoglobine",
])

let biology = syms([
    "NAD⁺|nicotinamide oxydé|coenzyme", "NADP⁺|NADP oxydé|coenzyme", "FADH₂|FAD réduit|coenzyme", "FMNH₂|FMN réduit|coenzyme", "QH₂|ubiquinol|coenzyme",
    "Vₘₐₓ|vitesse maximale|vmax enzyme michaelis", "Kₘ|constante de Michaelis|km enzyme", "V₀|vitesse initiale|enzyme", "Kₐ|constante d'acidité|ka", "pKₐ|pKa|acide tampon",
    "ΔG|enthalpie libre|gibbs energie", "ΔG°′|enthalpie libre standard|gibbs energie", "ΔH|variation d'enthalpie", "ΔS|variation d'entropie", "ΔE|variation d'énergie|potentiel",
    "T½|demi-vie|periode", "5′|extrémité 5 prime|adn arn", "3′|extrémité 3 prime|adn arn", "IP₃|inositol triphosphate", "PIP₂|phosphatidylinositol",
    "G₀|phase G0|cycle cellulaire", "G₁|phase G1|cycle cellulaire", "G₂|phase G2|cycle cellulaire", "T₃|triiodothyronine|thyroide", "T₄|thyroxine|thyroide",
    "B₁|vitamine B1|thiamine", "B₂|vitamine B2|riboflavine", "B₆|vitamine B6|pyridoxine", "B₁₂|vitamine B12|cobalamine", "D₃|vitamine D3|cholecalciferol",
    "C₁|vertèbre C1|atlas cervicale", "C₇|vertèbre C7|cervicale", "T₁|vertèbre T1|thoracique", "T₁₂|vertèbre T12|thoracique", "L₁|vertèbre L1|lombaire",
    "L₅|vertèbre L5|lombaire", "S₁|vertèbre S1|sacree", "V₁|nerf ophtalmique|trijumeau", "V₂|nerf maxillaire|trijumeau", "V₃|nerf mandibulaire|trijumeau",
])

let units = syms([
    "µm|micromètre|micron", "µg|microgramme", "µL|microlitre", "µM|micromolaire", "µmol|micromole",
    "µA|microampère", "µF|microfarad", "Å|ångström|angstrom", "°C|degré Celsius|temperature", "MΩ|mégohm|resistance",
    "m²|mètre carré|surface", "cm²|centimètre carré|surface", "mm²|millimètre carré|surface", "m³|mètre cube|volume", "cm³|centimètre cube|volume",
    "mm³|millimètre cube|volume", "m/s²|accélération|gravite", "kg/m²|indice de masse corporelle|imc", "kg/m³|masse volumique", "N/m²|pascal|pression",
    "W/m²|intensité|watt", "Pa·s|viscosité|pascal seconde", "s⁻¹|par seconde", "m⁻¹|par mètre", "L⁻¹|par litre",
    "mol⁻¹|par mole|avogadro", "K⁻¹|par kelvin", "kg⁻¹|par kilogramme", "J·K⁻¹|joule par kelvin|boltzmann", "J·mol⁻¹|joule par mole",
    "g·mol⁻¹|masse molaire", "kJ·mol⁻¹|kilojoule par mole", "cmH₂O|centimètre d'eau|pression",
])

let catalogue = negativePowers + positivePowers + greek + arrows + signs + powers + indices + chemistry + biology + units
let byValue = Dictionary(catalogue.map { ($0.value, $0) }, uniquingKeysWith: { a, _ in a })
func pick(_ values: [String]) -> [Sym] { values.map { byValue[$0] ?? Sym($0) } }

/// Classés d'après leur fréquence réelle dans les cours de l'année (comptage sur les fichiers de cours).
let essentialPowers = pick(["×10⁻⁹", "×10⁻⁷", "×10⁻⁶", "×10⁻⁵", "×10⁻³", "×10³", "×10⁶", "×10⁷", "×10⁹", "×10¹⁰"])
let essentials = pick([
    "→", "↔", "⇌", "↑", "↓", "←", "⇒", "⇄",
    "×", "−", "·", "≈", "≠", "≤", "≥", "±",
    "α", "β", "γ", "δ", "σ", "λ", "Δ", "µ",
    "⁺", "⁻", "²", "³", "₂", "₃", "°", "′",
])
/// Tant que l'historique n'est pas plein, la rangée du haut propose les plus fréquents des cours.
let starterRecents = ["Na⁺", "K⁺", "H⁺", "Ca²⁺", "CO₂", "O₂", "H₂O", "NAD⁺"]

let sections: [Section] = [
    Section(id: "star", label: "★", title: "Essentiels", groups: [
        Group(id: "ep", columns: 5, items: essentialPowers), Group(id: "ess", columns: 8, items: essentials),
    ]),
    Section(id: "pow10", label: "10ⁿ", title: "Puissances de 10", groups: [
        Group(id: "pn", columns: 5, items: negativePowers), Group(id: "pp", columns: 5, items: positivePowers),
    ]),
    Section(id: "greek", label: "αβ", title: "Grec", groups: [Group(id: "gr", columns: 8, items: greek)]),
    Section(id: "signs", label: "→≤", title: "Flèches et signes", groups: [
        Group(id: "ar", columns: 8, items: arrows), Group(id: "si", columns: 8, items: signs),
    ]),
    Section(id: "pow", label: "x²", title: "Exposants et indices", groups: [
        Group(id: "po", columns: 8, items: powers), Group(id: "in", columns: 8, items: indices),
    ]),
    Section(id: "chem", label: "Na⁺", title: "Ions et molécules", groups: [Group(id: "ch", columns: 5, items: chemistry)]),
    Section(id: "bio", label: "Bio", title: "Biochimie, cellule, anatomie", groups: [Group(id: "bi", columns: 5, items: biology)]),
    Section(id: "units", label: "µm", title: "Unités (biophysique)", groups: [Group(id: "un", columns: 5, items: units)]),
]

/// Ces signes s'affichent en emoji couleur par défaut : on force la version texte, à l'écran comme à la copie.
let textOnly: Set<String> = ["⚠"]
func output(_ s: String) -> String { textOnly.contains(s) ? s + "\u{FE0E}" : s }

let superOrSub = Set("⁰¹²³⁴⁵⁶⁷⁸⁹⁺⁻⁼⁽⁾ⁿ₀₁₂₃₄₅₆₇₈₉₊₋₌₍₎ₙ").map(String.init)
let asciiMap: [Character: Character] = {
    var m: [Character: Character] = [:]
    for (a, b) in zip("⁰¹²³⁴⁵⁶⁷⁸⁹⁺⁻⁼⁽⁾ⁿ", "0123456789+-=()n") { m[a] = b }
    for (a, b) in zip("₀₁₂₃₄₅₆₇₈₉₊₋₌₍₎ₙₐₘₓ", "0123456789+-=()namx") { m[a] = b }
    m["−"] = "-"; m["×"] = "x"
    return m
}()

func fold(_ s: String) -> String {
    String(s.map { asciiMap[$0] ?? $0 }).folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
}

/// Recherche sur le nom, les mots-clés et le symbole lui-même ; « hco3- » ou « ca2+ » trouvent aussi les ions.
func search(_ query: String) -> [Sym] {
    let q = fold(query.trimmingCharacters(in: .whitespaces))
    guard !q.isEmpty else { return [] }
    // « 10-23 », « x10^7 », « 10 14 » : n'importe quelle puissance de 10, même absente de la grille.
    var typedPower: [Sym] = []
    var typed = Substring(q.replacingOccurrences(of: " ", with: ""))
    if typed.hasPrefix("x") { typed = typed.dropFirst() }
    if typed.hasPrefix("10") {
        typed = typed.dropFirst(2)
        if typed.hasPrefix("^") { typed = typed.dropFirst() }
        if typed.count <= 4, !typed.hasPrefix("+"), let n = Int(typed) { typedPower = [power(n)] }
    }
    let scored: [(Int, Int, Sym)] = catalogue.enumerated().compactMap { i, s in
        let name = fold(s.name), keys = fold(s.keywords), value = fold(s.value)
        let score: Int
        if s.value == query { score = -1 }
        else if value == q { score = 0 }
        else if name == q { score = 1 }
        else if name.hasPrefix(q) || value.hasPrefix(q) { score = 2 }
        else if (name + " " + keys).split(separator: " ").contains(where: { $0.hasPrefix(q) }) { score = 3 }
        else if name.contains(q) || keys.contains(q) || value.contains(q) { score = 4 }
        else { return nil }
        return (score, i, s)
    }
    let found = scored.sorted { ($0.0, $0.2.value.count, $0.1) < ($1.0, $1.2.value.count, $1.1) }.map(\.2)
    return typedPower + found.filter { !typedPower.contains($0) }
}

// MARK: - Grille

let cell: CGFloat = 36, gap: CGFloat = 2, pad: CGFloat = 8, radius: CGFloat = 24
let gridW = 8 * cell + 7 * gap
let pillW = gridW + 2 * pad
let gridH = 7 * cell + 4 * gap + 2 * 8           // Essentiels : 3 groupes, séparés de 8
let searchH: CGFloat = 30, tabH: CGFloat = 26, footerH: CGFloat = 16, stack: CGFloat = 6
let margin: CGFloat = 30                        // place laissée à l'ombre dans la fenêtre transparente
let panelSize = NSSize(width: pillW + 2 * margin,
                       height: 2 * pad + searchH + tabH + gridH + footerH + 3 * stack + 2 * margin)
let curve = Animation.timingCurve(0.22, 1, 0.36, 1, duration: 0.26)
func wideWidth(_ columns: Int) -> CGFloat { (gridW - CGFloat(columns - 1) * gap) / CGFloat(columns) }

// MARK: - État

@MainActor
final class Model: ObservableObject {
    @Published var query = "" { didSet { if query != oldValue { selected = query.isEmpty ? nil : 0 } } }
    @Published var section = "star" { didSet { selected = nil; hoverTitle = nil } }
    @Published var selected: Int?
    @Published var hovered: Sym?
    @Published var hoverTitle: String?
    @Published var copied: String?
    @Published var shown = false
    @Published var focusToken = 0
    @Published var recents: [String] = UserDefaults.standard.stringArray(forKey: "recents") ?? []
    var onDone: () -> Void = {}
    var dryRun = false

    var groups: [Group] {
        if !query.trimmingCharacters(in: .whitespaces).isEmpty {
            return [Group(id: "res", columns: 8, items: search(query).filter { $0.value.count <= 2 }),
                    Group(id: "resw", columns: 5, items: search(query).filter { $0.value.count > 2 })]
                .filter { !$0.items.isEmpty }
        }
        let current = sections.first { $0.id == section } ?? sections[0]
        if section == "star" {
            let row = recents + starterRecents.filter { !recents.contains($0) }
            return [Group(id: "rec", columns: 8, items: pick(Array(row.prefix(8))))] + current.groups
        }
        return current.groups
    }
    var flat: [Sym] { groups.flatMap(\.items) }
    var selectedSym: Sym? { selected.flatMap { $0 < flat.count ? flat[$0] : nil } }

    func reset() {
        query = ""; section = "star"; selected = nil; hovered = nil; hoverTitle = nil; copied = nil
        focusToken += 1
    }

    /// Déplace la sélection au clavier en tenant compte des groupes de largeurs différentes.
    func move(dx: Int, dy: Int) {
        let count = flat.count
        guard count > 0 else { return }
        guard let current = selected else { selected = 0; return }
        if dx != 0 { selected = min(max(current + dx, 0), count - 1); return }
        var start = 0
        for (g, group) in groups.enumerated() {
            let n = group.items.count
            if current < start + n {
                let local = current - start, col = local % group.columns, target = local + dy * group.columns
                if target >= 0 && target < n { selected = start + target; return }
                if dy > 0 && local / group.columns < (n - 1) / group.columns { selected = start + n - 1; return }
                if dy > 0, g + 1 < groups.count {
                    let next = groups[g + 1]
                    selected = start + n + min(col * next.columns / group.columns, next.items.count - 1)
                } else if dy < 0, g > 0 {
                    let prev = groups[g - 1], m = prev.items.count
                    let lastRow = (m - 1) / prev.columns * prev.columns
                    selected = start - m + min(lastRow + col * prev.columns / group.columns, m - 1)
                }
                return
            }
            start += n
        }
    }

    func copy(_ s: Sym) {
        guard copied == nil else { return }
        if !dryRun {
            let pb = NSPasteboard.general
            pb.clearContents()
            // ⌥ : « 10⁻³ » au lieu de « ×10⁻³ », pour une valeur seule comme 10⁻³ m.
            let bare = NSEvent.modifierFlags.contains(.option) && s.value.hasPrefix("×10")
            pb.setString(bare ? String(s.value.dropFirst()) : output(s.value), forType: .string)
            recents = [s.value] + recents.filter { $0 != s.value }
            recents = Array(recents.prefix(8))
            UserDefaults.standard.set(recents, forKey: "recents")
        }
        NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .now)
        withAnimation(.easeOut(duration: 0.12)) { copied = s.value }
        if !dryRun { DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { [weak self] in self?.onDone() } }
    }
}

// MARK: - Vues

struct CellStyle: ButtonStyle {
    var selected = false, capsule = false
    var onHover: (Bool) -> Void = { _ in }
    func makeBody(configuration: Configuration) -> some View {
        CellBody(configuration: configuration, selected: selected, capsule: capsule, onHover: onHover)
    }
}

struct CellBody: View {
    let configuration: ButtonStyleConfiguration
    let selected: Bool, capsule: Bool
    let onHover: (Bool) -> Void
    @State private var hover = false

    var body: some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.88 : (hover && !capsule ? 1.1 : 1))
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: hover)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
            .background {
                Capsule().fill(Color.primary.opacity(selected ? 0.16 : (hover ? 0.09 : 0)))
                    .animation(.easeOut(duration: 0.14), value: hover)
            }
            .contentShape(Capsule())
            .onHover { hover = $0; onHover($0) }
    }
}

struct PillView: View {
    @ObservedObject var model: Model
    @FocusState private var searching: Bool

    var body: some View {
        VStack(spacing: stack) {
            searchField
            tabs
            grid
            footer
        }
        .padding(pad)
        .frame(width: pillW)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: radius, style: .continuous))
        .shadow(color: Color(nsColor: .shadowColor).opacity(0.25), radius: 14, y: 6)
        .scaleEffect(model.shown ? 1 : 0.95, anchor: .top)
        .opacity(model.shown ? 1 : 0)
        .padding(margin)
        .fixedSize()
        .onChange(of: model.focusToken) { searching = true }
        .onAppear { searching = true }
    }

    var searchField: some View {
        HStack(spacing: 7) {
            Image(systemName: "magnifyingglass").font(.system(size: 13, weight: .medium)).foregroundStyle(.secondary)
            TextField("Rechercher : alpha, flèche, calcium…", text: $model.query)
                .textFieldStyle(.plain)
                .font(.system(size: 13))
                .focused($searching)
            if !model.query.isEmpty {
                Button { model.query = "" } label: {
                    Image(systemName: "xmark.circle.fill").font(.system(size: 12)).foregroundStyle(.tertiary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Effacer la recherche")
            }
        }
        .padding(.horizontal, 10)
        .frame(height: searchH)
        .background(Capsule().fill(Color.primary.opacity(0.07)))
    }

    var tabs: some View {
        HStack(spacing: gap) {
            ForEach(sections) { s in
                let active = model.section == s.id && model.query.isEmpty
                Button {
                    withAnimation(.easeOut(duration: 0.12)) { model.query = ""; model.section = s.id }
                } label: {
                    Text(s.label)
                        .font(.system(size: 12, weight: active ? .semibold : .regular))
                        .foregroundStyle(active ? .primary : .secondary)
                        .frame(width: cell, height: tabH)
                }
                .buttonStyle(CellStyle(selected: active, capsule: true) { model.hoverTitle = $0 ? s.title : nil })
                .accessibilityLabel(s.title)
            }
        }
    }

    var grid: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                let groups = model.groups
                VStack(alignment: .leading, spacing: 8) {
                    if groups.isEmpty {
                        Text("Aucun symbole pour « \(model.query) »")
                            .font(.system(size: 12)).foregroundStyle(.secondary)
                            .frame(width: gridW, height: gridH)
                    }
                    ForEach(groups) { group in
                        groupView(group, offset: offset(of: group, in: groups))
                    }
                }
                .frame(width: gridW, alignment: .topLeading)
            }
            .frame(width: gridW, height: gridH)
            .mask(LinearGradient(stops: [.init(color: .black, location: 0.96), .init(color: .clear, location: 1)],
                                 startPoint: .top, endPoint: .bottom))   // suggère qu'il y a une suite
            .onChange(of: model.selected) { _, new in
                if let new, let s = model.flat[safe: new] { proxy.scrollTo(s.value + "\(new)") }
            }
        }
    }

    func offset(of group: Group, in groups: [Group]) -> Int {
        groups.prefix { $0.id != group.id }.reduce(0) { $0 + $1.items.count }
    }

    func groupView(_ group: Group, offset: Int) -> some View {
        let width = group.columns == 8 ? cell : wideWidth(group.columns)
        return LazyVGrid(columns: Array(repeating: GridItem(.fixed(width), spacing: gap), count: group.columns),
                         alignment: .leading, spacing: gap) {
            ForEach(Array(group.items.enumerated()), id: \.offset) { i, s in
                symbolButton(s, index: offset + i, width: width)
                    .id(s.value + "\(offset + i)")
            }
        }
    }

    func symbolButton(_ s: Sym, index: Int, width: CGFloat) -> some View {
        Button { model.copy(s) } label: {
            ZStack {
                if model.copied == s.value {
                    Image(systemName: "checkmark").font(.system(size: 14, weight: .semibold))
                } else {
                    label(s, width: width)
                }
            }
            .frame(width: width, height: cell)
        }
        .buttonStyle(CellStyle(selected: model.selected == index, capsule: width > cell) { on in
            if on { model.hovered = s } else if model.hovered == s { model.hovered = nil }
        })
        .accessibilityLabel(s.name)
    }

    @ViewBuilder func label(_ s: Sym, width: CGFloat) -> some View {
        if superOrSub.contains(s.value) {
            // un « x » grisé donne l'échelle : sans lui, ² ressemble à un 2 ordinaire
            HStack(spacing: 0) {
                Text("x").foregroundStyle(.tertiary)
                Text(s.value)
            }
            .font(.system(size: 18))
        } else if width > cell {
            Text(s.value).font(.system(size: 13)).lineLimit(1).minimumScaleFactor(0.7).padding(.horizontal, 3)
        } else {
            let size: CGFloat = s.value.count >= 3 ? 12 : s.value.count == 2 ? 15 : (["∝", "°", "∈", "∉"].contains(s.value) ? 23 : 19)
            Text(output(s.value)).font(.system(size: size)).lineLimit(1).minimumScaleFactor(0.6)
        }
    }

    var footer: some View {
        let shown = model.hovered ?? model.selectedSym
        let text: String
        if let c = model.copied { text = "Copié : \(c)" }
        else if let t = model.hoverTitle { text = t }
        else if let s = shown { text = "\(s.value) · \(s.name)" }
        else { text = sections.first { $0.id == model.section }?.title ?? "" }
        return Text(text)
            .font(.system(size: 11, weight: model.copied == nil ? .regular : .semibold))
            .foregroundStyle(model.copied == nil ? .secondary : .primary)
            .lineLimit(1)
            .frame(width: gridW, height: footerH)
    }
}

extension Array {
    subscript(safe i: Int) -> Element? { indices.contains(i) ? self[i] : nil }
}

// MARK: - Application

final class Panel: NSPanel { override var canBecomeKey: Bool { true } }

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    var item: NSStatusItem!
    let panel = Panel(contentRect: .zero, styleMask: [.borderless, .nonactivatingPanel], backing: .buffered, defer: false)
    let model = Model()
    var monitors: [Any] = []
    var session = 0
    let args = CommandLine.arguments
    func arg(_ name: String) -> String? {
        args.first { $0.hasPrefix("--\(name)=") }.map { String($0.dropFirst(name.count + 3)) }
    }
    var frozen: Bool { args.contains("--center") }

    func applicationDidFinishLaunching(_ n: Notification) {
        if let a = arg("appearance") { NSApp.appearance = NSAppearance(named: a == "light" ? .aqua : .darkAqua) }
        installEditMenu()
        item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        item.isVisible = true           // récupère l'icône si elle a été retirée de la barre avec ⌘-glisser
        if let b = item.button {
            b.image = NSImage(systemSymbolName: "function", accessibilityDescription: "Symboles")
            b.image?.isTemplate = true
            b.target = self
            b.action = #selector(clicked)
            b.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = false         // ombre SwiftUI, dans la marge transparente de la fenêtre
        panel.level = .floating
        panel.hidesOnDeactivate = false
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]   // visible aussi par-dessus le plein écran
        let host = NSHostingView(rootView: PillView(model: model))
        host.sizingOptions = []
        panel.contentView = host
        model.onDone = { [weak self] in self?.close() }
        model.dryRun = frozen

        let defaults = UserDefaults.standard
        let firstLaunch = !defaults.bool(forKey: "launchedOnce")
        if !frozen {
            defaults.set(true, forKey: "launchedOnce")
            syncLoginItem(firstLaunch: firstLaunch)
        }
        if args.contains("--debug") { print("ouverture de session :", SMAppService.mainApp.status.rawValue); fflush(stdout) }
        if args.contains("--show") || frozen {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.show(); self.applyTestState() }
        }
    }

    /// Relancer l'app (Spotlight, Finder) ouvre le panneau : utile si l'icône est cachée par l'encoche.
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if monitors.isEmpty { show() }
        return false
    }

    /// Sans menu Édition, ⌘V, ⌘A, etc. n'atteignent pas le champ de recherche.
    func installEditMenu() {
        let main = NSMenu(), holder = NSMenuItem(), edit = NSMenu(title: "Édition")
        for (title, action, key) in [("Annuler", Selector(("undo:")), "z"), ("Couper", #selector(NSText.cut(_:)), "x"),
                                     ("Copier", #selector(NSText.copy(_:)), "c"), ("Coller", #selector(NSText.paste(_:)), "v"),
                                     ("Tout sélectionner", #selector(NSText.selectAll(_:)), "a")] {
            edit.addItem(withTitle: title, action: action, keyEquivalent: key)
        }
        holder.submenu = edit
        main.addItem(holder)
        NSApp.mainMenu = main
    }

    /// Ouverture de session : activée une fois au premier lancement, ensuite le choix du menu fait foi.
    func syncLoginItem(firstLaunch: Bool) {
        let defaults = UserDefaults.standard
        if firstLaunch { defaults.set(true, forKey: "loginItem") }
        let status = SMAppService.mainApp.status
        if defaults.bool(forKey: "loginItem"), status == .notRegistered || status == .notFound {
            do { try SMAppService.mainApp.register() } catch { print("ouverture de session :", error); fflush(stdout) }
        }
    }

    @objc func toggleLoginItem() {
        let on = SMAppService.mainApp.status == .enabled
        if on { try? SMAppService.mainApp.unregister() } else { try? SMAppService.mainApp.register() }
        UserDefaults.standard.set(!on, forKey: "loginItem")
    }

    @objc func clicked() {
        let event = NSApp.currentEvent
        if event?.type == .rightMouseUp || event?.modifierFlags.contains(.control) == true {
            if !monitors.isEmpty { close() }
            let menu = NSMenu()
            let login = menu.addItem(withTitle: "Ouvrir à l'ouverture de session", action: #selector(toggleLoginItem), keyEquivalent: "")
            login.target = self
            login.state = SMAppService.mainApp.status == .enabled ? .on : .off
            menu.addItem(.separator())
            menu.addItem(withTitle: "Quitter", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
            item.menu = menu
            item.button?.performClick(nil)
            item.menu = nil
        } else if monitors.isEmpty { show() } else { close() }   // monitors vide : fermé ou en train de s'effacer
    }

    /// Point d'accroche sous l'icône. Barre de menu masquée (plein écran) ou icône cachée : le cadre est vide,
    /// on s'accroche alors en haut de l'écran où se trouve la souris, sous la zone de l'encoche.
    func anchor() -> (screen: NSScreen, x: CGFloat, y: CGFloat)? {
        if let w = item.button?.window, let s = w.screen, w.frame.width > 0, w.frame.height > 0,
           s.frame.contains(CGPoint(x: w.frame.midX, y: w.frame.midY)) {
            return (s, w.frame.midX, w.frame.minY)
        }
        let mouse = NSEvent.mouseLocation
        guard let s = NSScreen.screens.first(where: { $0.frame.contains(mouse) }) ?? NSScreen.main else { return nil }
        return (s, s.frame.midX, s.frame.maxY - max(s.safeAreaInsets.top, s.frame.maxY - s.visibleFrame.maxY))
    }

    func show() {
        guard let (screen, ax, ay) = anchor() else { return }
        session += 1
        model.reset()
        let size = panelSize
        let visible = screen.frame
        var x = ax - size.width / 2
        var top = ay - 6 + margin
        if frozen {                                     // pour les vérifications : au milieu de l'écran
            x = visible.midX - size.width / 2
            top = visible.midY + size.height / 2
        }
        x = min(max(x, visible.minX + 8 - margin), visible.maxX - size.width - 8 + margin)
        panel.setFrame(NSRect(x: x.rounded(), y: (top - size.height).rounded(), width: size.width, height: size.height), display: false)
        panel.alphaValue = 1
        model.shown = false
        panel.orderFrontRegardless()
        panel.makeKey()
        DispatchQueue.main.async { [self] in
            model.focusToken += 1
            withAnimation(curve) { model.shown = true }
        }
        monitors = [
            NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
                MainActor.assumeIsolated { if self?.frozen == false { self?.close() } }
            } as Any,
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] e in
                var handled = false
                MainActor.assumeIsolated { handled = self?.handleKey(e) ?? false }
                return handled ? nil : e
            } as Any,
        ]
    }

    func handleKey(_ e: NSEvent) -> Bool {
        switch e.keyCode {
        case 53:                                        // Échap : efface la recherche, puis ferme
            if model.query.isEmpty { close() } else { model.query = "" }
        case 36, 76:                                    // Entrée : copie la sélection
            if let s = model.selectedSym { model.copy(s) } else if model.flat.count > 0 { model.selected = 0 }
        case 123: model.move(dx: -1, dy: 0)
        case 124: model.move(dx: 1, dy: 0)
        case 125: model.move(dx: 0, dy: 1)
        case 126: model.move(dx: 0, dy: -1)
        case 48:                                        // Tab : section suivante / précédente
            guard let i = sections.firstIndex(where: { $0.id == model.section }) else { return true }
            let step = e.modifierFlags.contains(.shift) ? sections.count - 1 : 1
            model.query = ""
            model.section = sections[(i + step) % sections.count].id
        default: return false
        }
        return true
    }

    func close() {
        guard !monitors.isEmpty else { return }
        monitors.forEach { NSEvent.removeMonitor($0) }
        monitors = []
        let s = session
        NSAnimationContext.runAnimationGroup({ c in
            c.duration = 0.12
            panel.animator().alphaValue = 0
        }, completionHandler: { [weak self] in
            MainActor.assumeIsolated {
                guard let self, self.session == s else { return }
                self.panel.orderOut(nil)
                self.model.shown = false
            }
        })
    }

    /// --center --section=… --query=… --select=n --copied : fige un état pour la capture d'écran.
    func applyTestState() {
        if let s = arg("section") { model.section = s }
        if let q = arg("query") { model.query = q }
        if let n = arg("select").flatMap(Int.init) { model.selected = n }
        if args.contains("--copied"), let s = model.flat.first { model.copy(s) }
        if args.contains("--selftest") {
            for q in ["alpha", "ca2+", "hco3-", "fleche", "µ", "micro", "demi-vie", "10-3", "x10^10", "10-34", "10 7", "×10", "nano", "zzz"] {
                print(q, "→", search(q).prefix(5).map(\.value))
            }
            let dup = Dictionary(grouping: catalogue, by: \.value).filter { $0.value.count > 1 }.map(\.key)
            print("doublons :", dup, "· total :", catalogue.count)
            print("essentiels sans fiche :", essentials.filter { byValue[$0.value] == nil }.map(\.value))
            model.section = "signs"
            model.selected = 15
            model.move(dx: 0, dy: 1); print("med 15↓", model.selected ?? -1)
            model.move(dx: 0, dy: -1); print("↑", model.selected ?? -1)
            model.selected = 0; model.move(dx: 0, dy: -1); print("0↑", model.selected ?? -1)
            model.section = "star"
            model.selected = nil
            // Frappe, Entrée, Échap et ⌘A passent par le vrai circuit des événements.
            func key(_ c: String, _ code: UInt16, _ mods: NSEvent.ModifierFlags = []) {
                let e = NSEvent.keyEvent(with: .keyDown, location: .zero, modifierFlags: mods, timestamp: 0,
                                         windowNumber: panel.windowNumber, context: nil, characters: c,
                                         charactersIgnoringModifiers: c, isARepeat: false, keyCode: code)!
                NSApp.sendEvent(e)
            }
            print("fenêtre clé :", panel.isKeyWindow, "· répondeur :", type(of: panel.firstResponder!))
            for (c, code) in [("c", UInt16(8)), ("a", UInt16(0))] { key(c, code) }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                print("après frappe :", model.query, "· sélection :", model.selected ?? -1)
                let editor = panel.firstResponder as? NSTextView
                editor?.setSelectedRange(NSRange(location: 0, length: 0))
                key("a", 0, .command)
                print("⌘A sélectionne :", editor?.selectedRange().length ?? -1)
                key("", 125); print("↓ :", model.selected ?? -1)
                key("\u{1B}", 53); print("Échap vide la recherche :", model.query.isEmpty)
                fflush(stdout)
            }
            fflush(stdout)
        }
    }
}

@main
struct SymbolPillApp {
    @MainActor static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.setActivationPolicy(.accessory)
        app.run()
    }
}
