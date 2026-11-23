---
name: copilot-review-workflow
description: |
  PR に GitHub Copilot をレビュワーとしてリクエストし、指摘への対応 → push → 再レビューを
  指摘がなくなるまで繰り返した上で、人間ユーザーの最終確認に渡す一連の流れを実行します。
  ユーザーが PR に Copilot レビューを依頼したい、Copilot の指摘に対応したい、と言ったときに使用してください。
  レビュワーとしてのリクエスト（コメントでのメンションは変更依頼扱いになるため使わない）、
  対応要否の判断基準、迷ったときは人間に確認する、マージは人間が行う、という慣習を遵守します。
allowed-tools: Bash, Read, Edit, Grep, Glob, Skill, Monitor, AskUserQuestion
---

# Copilot レビューワークフロー

PR に GitHub Copilot のレビューを依頼し、指摘に対応してから人間の最終確認に渡すまでの一連の流れ。

## 進め方チェックリスト

着手時にこのチェックリストを応答へコピーし、進捗を更新する：

```
- [ ] 1. Copilotをレビュワーとしてリクエスト
- [ ] 2. レビュー結果を待つ（Monitor、sleepループでポーリングしない）
- [ ] 3. 指摘を確認・分類
- [ ] 4. 対応要否を判断（迷う指摘は人間に確認）
- [ ] 5. 対応した指摘を修正してpush
- [ ] 6. 指摘が残っていれば1へ戻る
- [ ] 7. 指摘がなくなったら人間に最終確認を依頼（マージは人間が行う）
```

## 1. Copilotをレビュワーとしてリクエスト

コメントでのメンション（`@copilot`）は「変更依頼」扱いになってしまうため使わない。必ずレビュワーとしてリクエストする。

```bash
gh api repos/<owner>/<repo>/pulls/<PR番号>/requested_reviewers \
  -X POST \
  -f "reviewers[]=copilot-pull-request-reviewer[bot]"
```

`201 Created` が返ってもレビューが実際にリクエストされたかはこの時点で保証されない（直後に `requested_reviewers` を見ると空で返ることがある）。不安なら issue タイムラインで裏取りする：

```bash
gh api repos/<owner>/<repo>/issues/<PR番号>/timeline -q '.[] | select(.event=="review_requested") | .requested_reviewer.login'
```

この機能はリポジトリ／アカウントでCopilot code reviewが有効になっていることが前提。無効な場合はAPIがエラーを返さず黙って無視するので、しばらく待っても`reviews`が増えないなら有効化状況をやっとむに確認する。

## 2. レビュー結果を待つ

Monitorツールでレビュー件数の増加を監視する。sleepループで手動ポーリングしない。

    prev_count=$(gh api repos/<owner>/<repo>/pulls/<PR番号>/reviews -q 'length')
    # Monitorツールで reviews の length が "$prev_count" より大きくなるまで待つ
    gh api repos/<owner>/<repo>/pulls/<PR番号>/reviews -q '.[-1] | "\(.user.login): \(.state)"'

## 3. 指摘を確認

レビュー本文とインラインコメントの両方を取得する（インラインコメントはレビュー本文だけでは見えないことがある）。

```bash
review_id=$(gh api repos/<owner>/<repo>/pulls/<PR番号>/reviews -q '.[-1].id')
gh api repos/<owner>/<repo>/pulls/<PR番号>/reviews -q '.[-1].body'
gh api repos/<owner>/<repo>/pulls/<PR番号>/reviews/$review_id/comments -q '.[] | "\(.path):\(.line) \(.body)"'
```

「Approval recommended」かつ指摘0件なら、ステップ7（人間への最終確認）へ進む。

## 4. 対応要否の判断

**なんでも対応するのではなく、本当に必要と判断した場合のみ対応する。**

- PRのスコープ内の指摘（今回の差分に対する指摘）: 妥当だと判断できるものは直す。
- PRのスコープ外の指摘（既存の記述・コードについての指摘）: このPRでは触らず、別issueとして切り出す。
- **対応するかどうか自分だけで判断がつかない指摘は、やっとむに確認する。**

スコープ外の指摘を別issueにする場合：

```bash
gh issue create --repo <owner>/<repo> --title "<簡潔なタイトル>" --body "$(cat <<'EOF'
## 内容
...

## 対応
...

## 経緯
PR #<N> のCopilotレビューで指摘された。PR自体のスコープ外のため、別issueとして切り出した。
EOF
)"
```

## 5. 修正してpush

通常のコミット規約（日本語・常態）に従う。push後は6へ。

## 6. 指摘がなくなるまで繰り返す

pushするたびにステップ1（Copilot再レビュー依頼）〜4を繰り返す。指摘が0件になるまで続ける。

## 7. 人間の最終確認

指摘がなくなったら、対応した内容（直したもの／別issueに切り出したもの）とPRのURLを添えて、やっとむに最終確認を依頼する。

**マージは人間が行う。このスキルではマージしない。**

## 注意

- レビュー依頼は必ずレビュワーとしてのリクエストで行う。コメントでのメンションは使わない。
- 指摘への対応可否を独断で決めきれないときは、必ず人間に確認する。
- worktreeなど新しい作業ツリーでpushする場合、pre-pushフックなどテストが依存関係未インストールで失敗することがある。リポジトリの環境構築方法を参照して設定すること。
