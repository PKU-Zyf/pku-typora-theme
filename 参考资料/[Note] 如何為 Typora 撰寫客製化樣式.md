# [Note] 如何為 Typora 撰寫客製化樣式

> 此文件翻譯自 [Write Custom Theme for Typora](http://theme.typora.io/doc/Write-Custom-Theme/) @ [Typora 官網](https://typora.io/)。翻譯時間為 2018-04-24。

## 總結

如果你想要為 Typora 撰寫客製化的樣式，你需要：

1. 建立一個新的 css 檔案，這個檔案的名稱**不能包含大寫字母或空格**，例如，`my-typora-theme` 就是一個有效的檔案名稱。
2. 寫 CSS 檔案。

- 我們準備了一個  [toolkit](https://github.com/typora/typora-theme-toolkit) 讓你可以快速開始，並做一些簡單的測試。
- 如果你是要從開始寫，可以從裡面的 `template.less` 開始。
- 如果你想要套用 Wordpress 或 Jekyll 等現有主題的 css 檔案，只要把內容複製下來，加上那些在 css 檔案中沒有涵括到的部分樣式，像是 “toc” 的樣式，或是其他的 UI 元素。

1. 檢測／除錯你的 CSS 檔案：

- 將你所建立的 CSS 檔案放入 `toolkit/theme/test.css` 中，並記得放入你引用到的圖片或字體檔，接著打開在 `toolkit/core` 和 `toolkit/electron` 內的 HTML 檔案來預覽你的 CSS。若你的作業系統是 Mac 則使用 Safari 來開啟該檔案，若是在 Linux/Windows 下，則使用 Chrome 來開啟。
- 接著跟著 [how to install custom theme](http://theme.typora.io/doc/Install-Theme/) 的說明來將你的樣式安裝到 Typora 上作為測試。

1. 如果你想要分享你的主題，只要 fork 一份，並發送 PR 到 [Typora Theme Gallery](http://theme.typora.io/doc/Write-Custom-Theme/typora-theme-gallery) 上即可。

## 基本

1. css 命名的規則：不要使用大寫字母，將空白以 `-` 替換掉，typora 會將它們轉換成在選單中可讀的名稱。舉例來說，`my-first-typora-theme.css` 會在 typora 的 “Themes” 選單項目中變成 “My First Typora Theme”
2. **將預設的字體大小放到 `html` 中，接著像是 `h1` 或 `p` 則使用 `rem` 作為單位**，否則的話，在偏好設定中所設定的客製化字體大小將不會生效。
3. Typora 是在 macOS 上是透過 Webkit，在 Windows/Linux 上是透過 Chromium，因此需使用 Chrome 或 Safari 所支援的 css 樣式。
4. 有些 CSS 的調整可能會使得 Typora 產生未預期的情況，例如在 `#write` 將上 `white-space: pre-wrap;`，將使得編輯時無法透過 Tab 鍵來插入 `\t`，因此請盡可能不要複寫預設的 CSS 樣式，並且試試看會不會產生錯誤。

## 我該用哪個 CSS 選擇器？

### 一般來說

`html`：Typora 的視窗內容是一個網頁，因此**請把 `background`, `font-family` 或起它通用的屬性添加到 `html` 標籤上**。在 Mac 上如果，如果你使用了 *seamless window style* ，那麼工具列的背景顏色將會套用在 html 上的 *background-color* 樣式。

`#write`：寫作的區域是套個 `#write`，改變它的 `width`, `height`, `padding` 將會調整寫作區域的尺寸。你所設定的屬性，像是添加在 `html` 上的 `color` 樣式，會套用在整個 window 內容； UI 也是，像是插入表格時視窗的文字顏色。因此，**如果你只想要改變寫作區域的樣式而不影響到 UI 的部分，則可以把樣式放在 `#write` 上。

```
/** example **/
html, body {
  background-color: #fefefe; /*background color of the window and title bar*/
  font-family: helvetica, sans-serif; /*custom font*/
  ...
}

html {
  font-size: 14px; /*default font size*/
}

#write {
  max-width: 90%; /*adjust size of the writing area*/
  font-size: 1rem; /*basic font size*/
  color: #555; /*basic font color*/
  ...
}
```

Typora 會試圖渲染所有 markdown 中的元素，所以段落會被 `<p>` 標籤包住，清單會被 `<ul>` 或 `<ol>` 包住，就如同其他 Markdown 處理器一樣，因此你可以透過改變這些 HTML 標籤的樣式來改變它們的外觀。也因此，Wordpress  或其他靜態頁面所使用的 CSS 檔案也會影響 Typora 中大部分的樣式，你可以直接「移植」這些 CSS  規則過來，並添加缺少的樣式或做些調整就好。

### Block Elements

如果前面所述，Typora 會是的渲染所有 Markdown 的元素，例如段落用 `<p>`、表格用 `<table>`、第一街的標題用 `<h1>`，等等，你可以改變它們的樣式：

```
p {...}
h1 {...}
table {...}
table th td {...}
table tr:nth-child(2n) td {...}
...
```

你可以在這些選擇器前面加上 `#write` 讓它們只套用於寫作區域而不會影響到其他的控制元件，例如，某些對話方框中的標題是套用 `h4` 的標籤：

```
/*this will only apply to h4 in dialogs popped up by typora (just an example)*/
.dialog h4 {...}

/*this will only apply to h4 inside writing area, which is generated after user input "#### " */
#write h4 {...}
```

此外，所有的區塊元素都有 `mdtype` 這個屬性，舉例來說，你可以透過 `[mdtype="heading"]` 來選到標題，其他的類型像是 `paragraph`, `heading`, `blockquote`, `fences`, `hr`, `def_link`, `def_footnote`, `table`, `meta_block`, `math_block`, `list`, `toc`, `list_item`, `table_row`, `table_cell`, `line`，**但大部分的情況下，使用 HTML 標籤就已經非常足夠**

| mdtype                                    | Output Css Selector                                         | Explanation                                                  |
| ----------------------------------------- | ----------------------------------------------------------- | ------------------------------------------------------------ |
| paragraph                                 | p                                                           |                                                              |
| line                                      | .md-line                                                    | A paragraph can contain one or more `.md-line`               |
| heading                                   | h1~h6                                                       |                                                              |
| blockquote                                | blockquote                                                  |                                                              |
| list (unordered list)                     | ul li                                                       |                                                              |
| list (ordered list)                       | ol li                                                       |                                                              |
| list (task)                               | ul.task-list li. task-list-item                             |                                                              |
| toc                                       | .md-toc                                                     | Also refer to [this doc][toc]                                |
| fences (before codemirror is initialized) | pre.md-fences.mock-cm                                       |                                                              |
| fences                                    | pre.md-fences                                               | please refer to “Code Fences” section                        |
| diagrams                                  | pre[lang=’sequence’], pre[lang=’flow’], pre[lang=’mermaid’] | They are special code fences with certain code language.     |
| hr                                        | hr                                                          |                                                              |
| def_link                                  | .md-def-link                                                | with children `.md-def-name`, `.md-def-content`, `.md-def-title` |
| def_footnote                              | .md-def-footnote                                            | with children `.md-def-name`, `.md-def-content`              |
| meta_block                                | pre.md-meta-block                                           | content for YAML front matters                               |
| math_block                                | [mdtype=”math_block”]                                       | preview part is `.mathjax-block`, html content is generated via [MathJax](http://www.mathjax.org/). TeX editor is powered by [CodeMirror](http://codemirror.net/), please refer to “Code Fences” section |
| table                                     | table thead tbody th tr td                                  |                                                              |

#### Lines

Typroa 會渲染如實的渲染斷行，因此，一個段落中會透過 `\n` 來包含許多行，而 `.md-line` 就是用來選擇 `<p>` 中的每一行。

#### Code Fences（程式碼區塊）

程式碼高亮的效果是透過  [CodeMirror](http://codemirror.net/) 的功能來達到，因此可以參 [這份文件](http://support.typora.io/Code-Block-Styles) 來檢視更多細節。

#### Mermaid（流程圖）

Markdown 中的流程圖式透過 [Mermaid](https://github.com/knsv/mermaid) 完成。

### Inline Elements

行內元素也會如同多數的 markdown 解析器一樣的被渲染，因此你可以使用：

```
strong {
  font-weight: bold;
}
em {..}
code {..}
a {..}
img {..}
mark {..} /*highlight*/
```

行內元素通常會被 `span` 、meta syntax 或最後輸出的行內元素所包住，例如，`**strong**` 會被渲染成：

```
<!--wrapper for strong element-->
<span md-inline="strong" class="">

  <!--meta syntax for strong element-->
  <span class="md-meta md-before">**</span>

    <!--output for strong element-->
    <strong>
      <!--inner output-->
      <span md-inline="plain">strong</span>
    </strong>

   <!--meta syntax for strong element-->
  <span class="md-meta md-after">**</span>
</span>
```

如你所見，整個行內元素被帶有 `md-inline` 屬性的 `span` 所包住，用來指稱解析後的結果，其他可能的屬性包含（有些行內元素需要在偏好設定中開啟）：

| `md-inline` | syntax                            | Output Tag |
| ----------- | --------------------------------- | ---------- |
| plain       | `plain`                           | `span`     |
| strong      | `**strong**`                      | `strong`   |
| em          | `*em*`                            | `em`       |
| code        | `code`                            | `code`     |
| underline   | `<u>underline</u>`                | `u`        |
| escape      | `\(`                              | `span`     |
| tag         | `<button>`                        |            |
| del         | `~~del~~`                         | `del`      |
| footnote    | `^1`                              | `sup`      |
| emoji       | `:smile:`                         | `span`     |
| inline_math | `$x^2$`                           | `span`     |
| subscript   | `~sub~`                           | `sub`      |
| superscript | `^sup^`                           | `sup`      |
| linebreak   | (two whitespace at end of a line) |            |
| highlight   | `==highlight==`                   | `mark`     |
| url         | `http://typora.io`                | `a`        |
| autolink    | `<http://typora.io>`              | `a`        |
| link        | `[link](href)`                    | `a`        |
| reflink     | `[link][ref]`                     | `a`        |
| image       | `![img](src)`                     | `img`      |
| refimg      | `![img][ref]`                     | `img`      |

下面會說明 Typora 如何為行內的 markdown 語法添加樣式，像是 `*` 或 `_` ，這些通常會在 Typroa 中被隱藏起來，而你通常也不需要個別為它們設定 CSS 規則。

大部分的語法像是 `**` 或 `==` 會在你將 markdown 轉換成 HTML 後消失，因此他們被 `md-meta` 的 class 所包住，並且預設會帶有 `display:none` ，一些像是 markdown 中圖片的語法預設會被隱藏，並且被以 `md-content` 的 class 所包住。當你的游標在這個行內元素時，被關注（focus）的那個將會被 `md-expand` class 所包住，接著 `.md-meta` 和 `.md-content` 會變成可見，所以**如果你想改變它們的外觀，將樣式套用在 `.md-meta` 和 `.md-content` 上**。

### 原始碼模式（Source Code Mode）

原始碼模式（SourceCode Mode）是透過 [CodeMirror](http://codemirror.net/) 的加持，所以它們所使用的語法高亮和程式碼區塊的樣式是一樣的（[檢視更多細節](http://support.typora.io/Code-Block-Styles)）。需要留意的是，**程式碼區塊使用 codemirror 主題的 `.cm-s-inner` ，但在程式碼模式下，codemirror 的主題是使用 `.cm-s-typora-default` **，所以 CSS 像這樣：

```
.cm-s-typora-default .cm-header {
  /*styles for h1~h6 in source code mode*/
}
```

### 專注模式（Focus Mode）

關於這個主題，可以參考[這份文件](http://support.typora.io/Change-Styles-in-Focus-Mode/)。

### 客製化字體（Custom Font）

關於這個主題，可以參考這份文件（目前暫無連結）。

### 背景（Background）

關於這個主題，可以參考 [這份文件](http://support.typora.io/Backgound/)。

### 控制 UI（Controller UI）

大部分的 UI 元件包括提示項目（tooltip）、對話框（dialog）和按鈕都是透過 HTML 所繪製。當你完成上面調整樣式的步驟後，如果發現這些 UI 和你的主題不搭時，你可以改變這些部分。在  [toolkit](https://github.com/typora/typora-theme-toolkit) 中的 HTML 檔案包含了大部分常用的 UI 元件，方便你可以除錯。

### 適用於 Windows/Linux 的其他 UI

相較於 macOS 的版本，Windows/Linux 版本的 Typora 使用了更多 HTML 的元素，包含清單（context  menu）、偏好設定（preference panel）、甚至是視窗的外框（如果你在 Windows 上使用的是 “unibody” 的  window style）。

在  [toolkit](https://github.com/typora/typora-theme-toolkit) 中的 HTML 檔案包含了大部分常用的 UI 元件，方便你可以除錯。

### 列印（Print）

在下面的區塊中所撰寫的 CSS 將只會套用到列印或匯出成 PDF 時套用：

```
@media print {
    /* for example: */
    .typora-export * {
        -webkit-print-color-adjust: exact;
    }
    /* add styles here */
}
```

## 除錯和測試（Debug and Test）

### 在瀏覽器中測試

我們在 [toolkit](https://github.com/typora/typora-theme-toolkit) 中 `html-preview` 資料夾內提供的 HTML 檔案讓你可以透過 Safari 或 Chrome 來預覽你的主題。使用它們時，重新命名你的檔案並將 CSS 檔案放在 `html-preview/theme/test.css` 內。

### 在 Typora 中測試

跟著[這份文件](http://theme.typora.io/doc/Install-Theme/)可以學習如何將主題安裝到 Typora 上。

對於 Mac 的使用者，在工具列「說明」的選單中可以勾選 `enable debug mode`，接著在內容上可以點選「檢閱元件（Inspect Element）」來跳出開發者工具。

對於 Windows/Linux 的使用者，你可以使用從「檢視」中切換 `Toggle DevTools` 來開關開發者工具。

## 客製化樣式的技巧和參考文件

相關的文件列在[這裡](http://support.typora.io/style)。

如果你有好的點子或用法想要分享，可以到 [typora-wiki-site](https://github.com/typora/wiki-website) 上發送 PR。

​      Tags:        [     app   ](https://pjchender.github.io/tags#app)   [     typora   ](https://pjchender.github.io/tags#typora)     

最後更新時間：2018-09-18