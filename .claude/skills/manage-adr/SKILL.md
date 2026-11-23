---
name: manage-adr
description: |
  Architecture Decision Records (ADRs)をADRディレクトリで管理します。
  新しいADRの作成、既存ADRの編集、ADR索引の確認を行います。
  ユーザーがアーキテクチャ決定の記録、ADRの作成・更新・検索を依頼したときに使用してください。
  番号の自動採番、プロジェクト固有のフォーマット（日本語、メタデータ構造）を遵守します。
allowed-tools: Read, Edit, Glob, Grep, Write
---

# ADR（Architecture Decision Record）管理スキル

このスキルはADRディレクトリ内のArchitecture Decision Recordsを、プロジェクト固有のルールに従って管理します。

## プロジェクト固有のルール

### ADRディレクトリ構造

ADRディレクトリが docs/adr/ の場合:

```
docs/adr/
├── 0001-security.md
├── 0002-realtime.md
├── 0003-cost.md
├── 0004-services.md
├── 0005-centralize-runtime-config.md
├── 0006-transcript-subscription-simplification.md
├── 0007-orchestrator-browser-interaction.md
├── 0008-chime-media-pipelines-for-server-side-transcription.md
├── 0009-third-party-meeting-service-integration.md
└── 0011-sqs-fifo-for-transcript-streaming.md
```

### ADRディレクトリの決め方

以下の順で決める。

1. 呼び出し時にパスが指定されていれば、それ
2. プロジェクトの CLAUDE.md / AGENTS.md に ADR の置き場所が書かれていれば、それ
3. Glob で `adr/`, `docs/adr/`, `*/adr/`, `*/docs/adr/` を探す
   - ちょうど1つ見つかれば、それ
   - 複数見つかった、または見つからなければ、ユーザーに確認する（勝手に作らない）

### ADRファイル命名規則

- ファイル名: `[4桁番号]-[ケバブケース説明].md`
- 例: `0001-security.md`, `0011-sqs-fifo-for-transcript-streaming.md`
- 番号は連番だが、欠番があってもOK（削除・スキップされたADRの場合）

### ADRメタデータフォーマット

各ADRファイルは以下のメタデータを含む必要があります：

```markdown
# ADR 0001: タイトル

- Status: Proposed | Accepted | Rejected | Superseded | TBD
- Date: YYYY-MM-DD
- Owners: プロジェクトチーム名 または 個人名
- History: （任意）ステータス遷移の記録
```

**各項目の意味**:

- **Status**: 現在の状態
- **Date**: **作成日。以後変更しない。** gitの作成日（`git log --diff-filter=A`）と一致するので、後から検証できる
- **Owners**: 責任者
- **History**: **ステータスが遷移したときだけ追記する。** `YYYY-MM-DD <新Status>（理由や関連ADR）` の形。遷移が無ければ行ごと不要

**なぜ Date を変更しないか**: Date を「最終更新日」にすると作成日が失われる。「決定日」として上書きすると、Proposed 期間のあるADRで提案日が失われる。**作成日を固定して遷移を追記すれば、どちらも残る。**

**Statusの意味**:
- **Proposed**: 提案段階（レビュー中）
- **Accepted**: 承認済み（実装中または実装済み）
- **Rejected**: 却下
- **Superseded**: 別のADRに置き換えられた
- **TBD**: 未決定（調査中、議論中）

### ADR構造テンプレート

```markdown
# ADR [番号]: タイトル

- Status: [Status]
- Date: [YYYY-MM-DD]
- Owners: [チーム名 または 個人名]

## 背景 / Context

[意思決定が必要になった背景、問題、要件]

## 決定 / Decision

[何を決定したか。明確に、簡潔に]

## 影響 / Consequences

[この決定によって生じる影響（ポジティブ、ネガティブ両方）]

## 代替案 / Alternatives Considered

[検討した他の選択肢とその理由]

## 参考 / References

[関連リンク、ドキュメント、関連ADR]
```

新規作成時は遷移がないので `History` は書かない。

### 言語

- **日本語で記述**: セクション見出しは「背景 / Context」のように日英併記
- 技術用語は英語でもOK（Kinesis, SQS, Lambda等）
- コード例、構造図は英語でOK

### 関連ADRの参照

ADR間で関連がある場合、明示的に参照する：

```markdown
## 参考 / References

### 関連ADR
- ADR 0002: リアルタイム性（レイテンシ要件）
- ADR 0003: コスト（コスト最適化方針）
- ADR 0007: Orchestratorとブラウザの連携
```

## 使用シナリオ

### 新規ADRの作成

1. **番号の確認**: ADRディレクトリをGlobで確認し、未使用の次の番号を決定
2. **テンプレート適用**: 上記のADR構造テンプレートを使用
3. **メタデータ設定**:
   - Status: 通常は"Proposed"または"TBD"でスタート
   - Date: 今日の日付（YYYY-MM-DD形式）
   - Owners: デフォルトは、プロジェクト内の既存ADRと同じOwner
   - History: 書かない（遷移がまだ無いため）
4. **ファイル作成**: Writeツールで新規ファイルを作成
5. **索引の更新**: ADRディレクトリに README.md があれば、一覧に追記する（タイトルと Status）

### 既存ADRの読み込み

1. **番号で検索**: Globで`<ADRディレクトリ>/[番号]*.md`パターンで検索
2. **キーワード検索**: Grepで内容を検索
3. **全ADR一覧**: Globで`<ADRディレクトリ>/*.md`を一覧表示

### 既存ADRの更新

1. **Readで読み込み**: 対象ADRファイルを読み込む
2. **メタデータ更新**:
   - Status変更（Proposed → Accepted等）
   - **History に追記**: `YYYY-MM-DD <新Status>（理由や関連ADR）`。行が無ければ Owners の下に作る
   - **Date は変更しない**（作成日のため）
3. **内容更新**: Editツールでセクションを追加・修正
4. **Superseded設定**: 別のADRに置き換えられた場合、古いADRのStatusを"Superseded"に変更し、参照を追記
5. **索引の更新**: ADRディレクトリに README.md があれば、更新内容を反映する（Status）

Supersededの書き方は以下の例を参考に。

```markdown
- Status: Superseded
- Date: 2026-08-08
- Owners: yattom
- History: 2026-08-12 Superseded（ADR 0010 により置き換え）

> **ADR 0010 により置き換えられた。**（置き換えの理由を1〜2文）
```

日付は History が持つので、引用ブロックには書かない。引用ブロックは「なぜ置き換わったか」だけを書く。

### ADR索引の確認

ADRディレクトリに README.md があれば索引として利用する。
存在しない場合は、ファイルを直接探す。全ADRを一覧する場合：

```bash
Glob: <ADRディレクトリ>/*.md
```

で一覧を取得し、ユーザーに提示する。

## 作業フロー

1. **読み込み**: ADRディレクトリの現在の状態を確認（Glob使用）
2. **番号確認**: 最新のADR番号を確認し、次の番号を決定
3. **テンプレート適用**: プロジェクト固有のフォーマットとメタデータを適用
4. **内容作成**: ユーザーの要件に基づいて各セクションを記述
5. **実行**: WriteまたはEditツールでファイルを作成・更新

## 例

### 良い例：新規ADR作成時

ユーザー: 「SQSの使用について新しいADRを書いて」

1. Glob で `<ADRディレクトリ>/*.md` を確認
2. 最新番号が0011なので、次は0012を使用
3. テンプレートを適用:

```markdown
# ADR 0012: SQS使用方針

- Status: Proposed
- Date: 2025-12-25
- Owners: timtam PoC チーム

## 背景 / Context

[SQS導入の背景]

## 決定 / Decision

[SQS使用の決定]

## 影響 / Consequences

[影響分析]

## 代替案 / Alternatives Considered

[他の選択肢]

## 参考 / References

[関連情報]
```

4. Write で `/home/yattom/work/timtam/docs/adr/0012-sqs-usage-policy.md` を作成
5. `docs/adr/README.md` があれば、一覧に「0012 SQS使用方針 / Proposed」を追記

### 良い例：既存ADRの更新

ユーザー: 「ADR 0011のStatusをAcceptedに変更して」（今日が 2026-01-10 の場合）

1. Read で `<ADRディレクトリ>/0011-*.md` を読み込む
2. Editでメタデータを更新:

変更前

```markdown
- Status: Proposed
- Date: 2025-12-25
- Owners: timtam PoC チーム
```

変更後

```markdown
- Status: Accepted
- Date: 2025-12-25
- Owners: timtam PoC チーム
- History: 2026-01-10 Accepted
```

**Date は作成日なので書き換えない。** 承認された日付は History が持つ。

3. README.md の索引があれば、0011 の Status を Accepted に直す

### 良い例：ADR検索

ユーザー: 「Kinesisに関するADRを教えて」

1. Grep で `pattern: "Kinesis"`, `path: <ADRディレクトリ>` を検索
2. 該当するADRファイルをリストアップ
3. ユーザーに提示

### 悪い例：番号の重複

❌ 既存のADR番号を再利用しない
❌ 番号を遡って挿入しない（0001と0002の間に0001.5を作らない）
✅ 常に最新番号+1を使用

### 悪い例：メタデータの省略

❌ Statusを省略
❌ Dateフォーマットが不統一（2025/12/25等）
✅ 必須メタデータ（Status, Date, Owners）を必ず含める

### 悪い例：日付の扱い

❌ Status を変えたときに Date を書き換える（作成日が失われる）
❌ Status を変えたのに History に追記しない（いつ決まったかが失われる）
❌ 本文の修正（typo直し、追記）で Date を更新する
✅ Date は作成日で固定。ステータス遷移は History に追記

## ユーザー依頼例

- 「新しいADRを作成して」
- 「ADR 0011をAcceptedに変更して」
- 「Kinesisに関するADRを探して」
- 「最新のADRを教えて」
- 「ADR 0008の内容を読んで」
- 「ADRの一覧を見せて」

## パス指定の注意

常に絶対パスを使用：
- ✅ `/home/yattom/work/timtam/docs/adr/0001-security.md`
- ❌ `docs/adr/0001-security.md`

## 補足：ADRのベストプラクティス

### いつADRを書くか

- アーキテクチャに影響する重要な技術選択をした時
- 複数の選択肢があり、トレードオフを検討した時
- 将来の意思決定者が「なぜこうしたのか」を知る必要がある時

### ADRに含めるべき内容

- **背景**: なぜこの決定が必要になったか
- **決定**: 何を選択したか（明確に）
- **理由**: なぜその選択をしたか
- **トレードオフ**: 何を得て、何を失うか
- **代替案**: 検討した他の選択肢と却下理由

### ADRに含めなくてよい内容

- 実装の詳細（コードで表現すべき）
- チュートリアル（ドキュメントで表現すべき）
- 変更履歴（Gitで管理されている）
