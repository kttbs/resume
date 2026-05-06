# kato's resume

このリポジトリは、職務経歴書を Markdown で管理し、校正・PDF 生成・GitHub Actions による公開や運用を行うためのものです。

## 構成

- `docs/index.md`: 職務経歴書の元データ
- `docs/index.pdf`: 生成した PDF
- `pdf-configs/config.js`: PDF 生成設定
- `pdf-configs/style.css`: PDF 用スタイル
- `.textlintrc`: textlint のルール設定

## セットアップ

```bash
yarn install
```

## できること

### 文章校正

`docs/index.md` を [textlint](https://github.com/textlint/textlint) でチェックできます。

```bash
yarn lint
```

- 校正ルールは `.textlintrc` で管理しています。
- pre-commit では [husky](https://github.com/typicode/husky) により `npm run lint` が実行されます。
- 現在は `--fix` 付きのスクリプトは定義されていません。

### PDF 生成

[md-to-pdf](https://www.npmjs.com/package/md-to-pdf) を使って `docs/index.md` から PDF を生成できます。

```bash
yarn build:pdf
```

- 出力先は `docs/index.pdf` です。
- 見た目を調整したい場合は `pdf-configs/style.css` を編集してください。
- 生成オプションは `pdf-configs/config.js` で管理しています。

### GitHub Actions による自動化

#### Lint

`push` と `pull_request` を契機に、GitHub Actions で `yarn lint` を実行します。

#### Release 用 PDF 生成

`v*` 形式のタグを push すると、GitHub Actions が以下を実行します。

- 依存関係のインストール
- PDF の生成
- GitHub Release の作成
- `docs/index.pdf` の Release Assets への添付

例:

```bash
git commit -m "update resume"
git tag v1.0.0
git push origin --tags
```

#### GitHub Pages への公開

`master` ブランチへの push、または手動実行で `docs/` を GitHub Pages にデプロイします。

#### 定期更新リマインド

3 か月ごとに Issue を自動作成し、職務経歴書の更新を促します。

- スケジュールは `.github/workflows/create-issue.yml`
- Issue の本文は `.github/ISSUE_TEMPLATE.md`
