# 📱 Guia para Gerar Release para Play Store

## 🔧 Configuração Inicial

### 1. Configurar Assinatura do APK

1. **Gerar Keystore** (faça isso apenas uma vez):
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. **Configurar key.properties**:
   - Edite o arquivo `android/key.properties`
   - Descomente e preencha com suas informações:
```properties
storePassword=SUA_SENHA_DO_KEYSTORE
keyPassword=SUA_SENHA_DA_CHAVE
keyAlias=upload
storeFile=../upload-keystore.jks
```

### 2. Configurar build.gradle

O arquivo `android/app/build.gradle` já está configurado para usar o keystore.

## 🚀 Gerar Release

### 1. Limpar e Preparar
```bash
flutter clean
flutter pub get
```

### 2. Gerar APK de Release
```bash
flutter build apk --release
```

### 3. Gerar App Bundle (Recomendado para Play Store)
```bash
flutter build appbundle --release
```

## 📁 Localização dos Arquivos

- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **App Bundle**: `build/app/outputs/bundle/release/app-release.aab`

## 📋 Checklist para Play Store

- [ ] Ícone do app configurado
- [ ] Nome do app definido
- [ ] Versão e build number atualizados
- [ ] Permissões necessárias declaradas
- [ ] Keystore configurado e seguro
- [ ] App Bundle gerado
- [ ] Testado em dispositivos reais

## 🔒 Segurança

- **NUNCA** commite o arquivo keystore no Git
- **NUNCA** commite senhas no código
- Mantenha backup seguro do keystore
- Use senhas fortes

## 📱 Configurações do App

### Ícone
- Localização: `android/app/src/main/res/`
- Tamanhos necessários: mipmap-hdpi, mipmap-mdpi, mipmap-xhdpi, mipmap-xxhdpi, mipmap-xxxhdpi

### Nome do App
- Arquivo: `android/app/src/main/AndroidManifest.xml`
- Tag: `android:label`

### Versão
- Arquivo: `pubspec.yaml`
- Campo: `version: 1.0.0+1`