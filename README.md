# 🔐 **LeChacal's Authenticator**

A custom-built two-factor authentication (2FA) application, similar to Google Authenticator, designed and developed from scratch.

## 📋 Overview

**LeChacal's Authenticator** is a personal project that implements Time-based One-Time Password (TOTP) authentication. This application provides a secure way to generate verification codes for your online accounts, offering an alternative to commercial authenticator apps.

## ✨ Features

- 🔢 Generate time-based one-time passwords (TOTP)
- 🔒 Secure local storage of authentication secrets
- ⏱️ Real-time code generation with countdown timer
- 📱 Clean and intuitive user interface
- 🎯 Compatible with services that support TOTP authentication

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:
- Latest version of Flutter
- A phone or a emulator

### Installation

```bash
# Clone the repository
git clone https://github.com/Dev-LeChacal/LeChacals-Authenticator.git

# Navigate to the project directory
cd LeChacals-Authenticator

# Install dependencies
flutter pub get
```

### Usage

```bash
flutter run
```

## 🔒 Security

This application stores sensitive authentication data. Please ensure:
- Keep your device secure
- Never share your secret keys

## 📝 How It Works

**LeChacal's Authenticator** uses the TOTP (Time-based One-Time Password) algorithm, which generates a unique code based on:
1. A shared secret key
2. The current time

The codes refresh every 30 seconds, providing an additional layer of security for your accounts.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

## 👤 Author

**LeChacal**

- GitHub: [@Dev-LeChacal](https://github.com/Dev-LeChacal)

## 🙏 Acknowledgments

- Inspired by Google Authenticator
- Thanks to the open-source community for TOTP libraries and resources

## ⚠️ Disclaimer

This is a personal project created for educational purposes. For production use, consider well-established and audited authentication solutions.

---

⭐ If you find this project useful, please consider giving it a star!
