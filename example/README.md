![alt text](assets/images/logo/banner-logo.png)

# Setting VSCODE

```json
"dart.lineLength": 150,
"dart.maxLogLineLength": 150,
"dart.previewFlutterUiGuides": true,
"editor.codeActionsOnSave": {
  "source.addMissingImports": "explicit",
  "source.addMissingRequiredArguments": "explicit",
  "source.addMissingRequiredNamedArguments": "explicit",
  "source.fixAll": "explicit",
  "source.organizeImports": "explicit"
},
"editor.formatOnSave": true,
"editor.formatOnType": true,
```

### Dependency Injection

get_it is used for dependency injection, ensuring the application is decoupled and modular.

### Networking

Dio is employed to facilitate remote API calls, enhancing the efficiency of data retrieval.

### Local Database

Isar is utilized for local database storage, enabling seamless offline access to previously viewed movies.

### Functional Programming

Dartz library is integrated to introduce functional programming concepts, resulting in more predictable and expressive code.

## Getting Started

To set up this application on your local machine, follow these steps:

1. **Clone the Repository:** Open a terminal and run the following command to clone the project repository

2. Install project dependencies:
   ```bash
   flutter clean && flutter pub cache clean --force && rm pubspec.lock && flutter pub get --no-example
   ```
3. Generate LocaleKeys:

   ```bash
   flutter pub run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart
   ```

4. Generate necessary code using `build_runner`:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Contributions

Contributions are welcome! If you want to contribute to the Flutter Movie Application, simply follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix: `git checkout -b feature/your-feature-name` or `bugfix/issue-number`.
3. Make your changes and commit them: `git commit -m 'Add some feature'`.
4. Push your changes to the branch: `git push origin feature/your-feature-name`.
5. Open a pull request against the `master` branch of the original repository.

Your contributions help enhance the FilmKu Flutter Movie Application. Feel free to propose new features, improve existing ones, or fix bugs. Together, we can make FilmKu even better!

### Generate model

Sometime you need generate model from tool [GetCLI](https://github.com/phatdat-dev/get_cli_basemodel_generator)

```bash
get generate model on models/response with assets/import_response.json --copyWith
# or
get generate model with assets/import_response.json
```

#### Install GETCLI

After clone [GetCLI](https://github.com/phatdat-dev/get_cli_basemodel_generator) you need run command below

```bash
dart pub global activate --source path .
```

get file .bat from `%USERPROFILE%\AppData\Local\Pub\Cache\bin`

### Commit message

- Feat (feature): một chức năng mới của dự án
- Fix: fix bug của dự án
- Chore: từ này dịch ra tiếng Việt là việc "lặt vặt" nên mình đoán là nó để chỉ những thay đổi không đáng kể trong code (ví dụ như thay đổi text chẳng hạn), vì mình cũng ít khi sử dụng type này.
- Refactor: refactor lại code hiện tại của dự án (refactor hiểu đơn giản là việc "làm sạch" code, loại bỏ code smells, mà không làm thay đổi chức năng hiện có)
- Docs: thêm/sửa đổi document của dự án (update readme)
- Style: thay đổi UI của dự án mà không ảnh hưởng đến logic.
- Test: thêm/sửa đổi test của dự án
- Perf: cải thiện hiệu năng của dự án (VD: loại bỏ duplicate query, ...)
- CI: cấu hình CI/CD cho dự án
- Build: những thay đổi ảnh hưởng đến hệ thống xây dựng hoặc các phần phụ thuộc bên ngoài
- Vendor: cập nhật phiên bản cho các packages, dependencies mà dự án đang sử dụng.

## Update

### Package [origin link](https://stackoverflow.com/questions/57764070/how-to-automatically-upgrade-flutter-dependencies)

```bash
# flutter clean
# flutter pub cache clean
# rm pubspec.lock
# flutter pub upgrade --major-versions
```

### IOS

[Click](https://stackoverflow.com/questions/59362862/flutter-ios-build-failed-an-error-of-pod-files-podfile-is-out-of-date)

```bash
# cd ios
# pod install --repo-update
# pod repo update
# pod install

# find . -type f -name '*.png' -exec xattr -c {} \;    # remove all xattr image error
# flutter clean && flutter pub get --no-example && cd ios && pod install --repo-update && cd ..
```

## Build

```bash
flutter build apk --release --split-per-abi
```
