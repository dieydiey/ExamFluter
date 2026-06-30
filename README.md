# ExamFluter```markdown
# 💰 BadWallet Mobile – Application Flutter

Application mobile multiplateforme (Android) de gestion de portefeuilles électroniques BadWallet.  
Développée avec **Flutter**, elle permet aux clients de consulter leur solde, effectuer des transferts, payer des factures et consulter l’historique de leurs transactions.

---

## 📱 Télécharger l’APK

Le fichier installable se trouve dans :  
`build/app/outputs/flutter-apk/app-release.apk`

---

## 🚀 Lancer l’application en développement

### 1. Prérequis

- Flutter SDK (version 3.x ou supérieure)
- Un émulateur Android ou un téléphone physique
- Backend Spring Boot démarré sur `http://localhost:8080`

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Lancer l’application

**Sur navigateur (Chrome) :**
```bash
flutter run -d chrome
```

**Sur émulateur Android :**
```bash
flutter run -d emulator
```

**Sur un téléphone physique :**
```bash
flutter run
```

---

## 📱 Générer l’APK de production

```bash
flutter build apk --release
```

L’APK se trouve dans :  
`build/app/outputs/flutter-apk/app-release.apk`

---

## 🏗️ Architecture du projet

L’application suit une architecture **« Feature-First »** avec une séparation claire des responsabilités :

```
lib/
├── core/
│   ├── services/          # ApiService, WalletService, BillsService
│   ├── theme/             # Thème et styles globaux
│   └── routes/            # Définition des routes de l’application
├── features/
│   ├── auth/              # Écran de connexion (saisie du téléphone)
│   ├── dashboard/         # Tableau de bord (solde, dernières transactions)
│   ├── transfers/         # Transfert d’argent entre wallets
│   ├── bills/             # Factures impayées et paiement
│   └── history/           # Historique complet des transactions
├── models/                # Classes de données (Wallet, Transaction, Facture)
└── main.dart              # Point d’entrée de l’application
```

---

## 🔐 Authentification (simulée)

L’authentification se fait par **saisie du numéro de téléphone**.  
Le numéro est stocké localement via `flutter_secure_storage` pour persister la session.

- Numéro valide : `+221770000001` (créé par le seeder)
- Après connexion, le Dashboard affiche le solde et les dernières transactions.

---

## 📡 Communication avec le backend

Les appels HTTP sont centralisés dans `ApiService` avec **Dio**.  
L’URL de base est configurable selon la plateforme :

| Plateforme  | URL par défaut |
|-------------|----------------|
| **Web**     | `http://localhost:8080` |
| **Android** (émulateur) | `http://10.0.2.2:8080` |
| **Physique** | `http://<IP_DE_LA_MACHINE>:8080` |

> ⚠️ Pour un test sur téléphone physique, remplace `localhost` par l’IP de votre machine dans `api_service.dart`.

---

## 🛠️ Technologies utilisées

| Technologie                | Utilisation |
|----------------------------|-------------|
| **Flutter**                | Framework multiplateforme |
| **Dio**                    | Client HTTP pour les requêtes API |
| **Provider**               | Gestion d’état (State Management) |
| **flutter_secure_storage** | Stockage sécurisé du numéro de téléphone |
| **intl**                   | Formatage des dates et de la monnaie (XOF) |
| **google_fonts**           | Typographie moderne (Poppins) |
| **shimmer**                | Effet de chargement |

---

## 📋 Fonctionnalités principales

| Fonctionnalité | Endpoint associé |
|----------------|------------------|
| **Connexion**  | (stockage local du numéro) |
| **Solde**      | `GET /api/wallets/{phone}/balance` |
| **Dernières transactions** | `GET /api/wallets/{phone}/transactions` |
| **Transfert d’argent** | `POST /api/wallets/transfer` |
| **Factures impayées** | `GET /api/external/factures/{walletCode}/current` |
| **Paiement de factures** | `POST /api/wallets/pay-factures` |
| **Historique complet** | `GET /api/wallets/{phone}/transactions` |

---

## 🧪 Tester avec des données initiales

Exécute le **seeder** depuis le backend Spring Boot :

```http
POST http://localhost:8080/api/wallets/seed?numWallets=10&eventsPerWallet=100
```

Il génère 10 wallets (`+221770000001` à `+221770000010`) avec des transactions.

---

## 📦 Structure des modèles

### Wallet
```dart
{
  id: int,
  phoneNumber: String,
  email: String,
  balance: double,
  code: String,
  currency: String
}
```

### Transaction
```dart
{
  id: int,
  type: "DEPOSIT" | "WITHDRAW" | "TRANSFER" | "PAYMENT",
  amount: double,
  fees: double,
  description: String,
  date: DateTime,
  receiverPhone: String?
}
```

### Facture
```dart
{
  id: int,
  reference: String,
  serviceName: String,
  walletCode: String,
  amount: double,
  dueDate: DateTime,
  paid: bool,
  paymentDate: DateTime?
}
```

---

## 🔧 Configuration de l’API

Dans `lib/core/services/api_service.dart` :

```dart
static const String baseUrl = 'http://10.0.2.2:8080'; // émulateur Android
```

Pour un **téléphone physique**, remplace par l’IP de votre machine :

```dart
static const String baseUrl = 'http://192.168.1.XX:8080';
```

---

## 📱 Génération de l’APK

```bash
flutter build apk --release
```

L’APK final se trouve dans :  
`build/app/outputs/flutter-apk/app-release.apk`

---

