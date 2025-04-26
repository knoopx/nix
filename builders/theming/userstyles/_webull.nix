{pkgs, ...}:
pkgs.writeTextFile {
  name = "whatsapp.userstyle.css";
  text = ''
    @-moz-document domain("app.webull.com") {
     html {
        --base00: #1e1e2e;
        --base01: #181825;
        --base02: #313244;
        --base03: #45475a;
        --base04: #585b70;
        --base05: #cdd6f4;
        --base06: #f5e0dc;
        --base07: #b4befe;
        --base08: #f38ba8;
        --base09: #fab387;
        --base0A: #f9e2af;
        --base0B: #a6e3a1;
        --base0C: #94e2d5;
        --base0D: #89b4fa;
        --base0E: #cba6f7;
        --base0F: #fad000;
      }

      * {
          font-family: "JetBrainsMono Nerd Font" !important;
      }

      .not-support-body {
        background-color: rgba(0, 0, 0, 0);
      }

      .not-support-body .content {
        color: rgb(238, 238, 238);
      }

      .not-support-body .content .link {
        color: rgb(238, 238, 238);
        border-bottom-color: rgb(238, 238, 238);
      }

      div,
      p,
      section {
        scrollbar-color: rgba(255, 255, 255, 0) rgba(255, 255, 255, 0);
      }

      a {
        color: rgb(58, 58, 58);
      }

      input::-webkit-input-placeholder,
      textarea::-webkit-input-placeholder {
        color: rgb(138, 141, 145);
      }

      input::placeholder,
      textarea::placeholder {
        color: rgb(138, 141, 145);
      }

      input:-moz-placeholder,
      textarea::placeholder {
        color: rgb(138, 141, 145);
      }

      ::-webkit-input-placeholder {
        color: rgb(123, 130, 136);
      }

      :-moz-placeholder {
        color: rgb(123, 130, 136);
      }

      ::placeholder {
        color: rgb(123, 130, 136);
      }

      .not-support-body {
        background-color: rgba(0, 0, 0, 0);
      }

      .not-support-body .content {
        color: rgb(238, 238, 238);
      }

      .not-support-body .content .link {
        color: rgb(238, 238, 238);
        border-bottom-color: rgb(238, 238, 238);
      }

      .simplebar-scrollbar::before {
        background-color: var(--base01);
      }

      .driver-popover {
        color: rgb(45, 45, 45);
        background-color: rgb(255, 255, 255);
      }

      .driver-popover-close-btn {
        color: rgb(210, 210, 210);
      }

      .driver-popover-close-btn:hover,
      .driver-popover-close-btn:focus {
        color: rgb(45, 45, 45);
      }

      .driver-popover-progress-text {
        color: rgb(114, 114, 114);
      }

      .driver-popover-footer button {
        background-color: rgb(255, 255, 255);
        color: rgb(45, 45, 45);
        border-top-color: rgb(204, 204, 204);
        border-right-color: rgb(204, 204, 204);
        border-bottom-color: rgb(204, 204, 204);
        border-left-color: rgb(204, 204, 204);
      }

      .driver-popover-footer button:hover,
      .driver-popover-footer button:focus {
        background-color: rgb(247, 247, 247);
      }

      .driver-popover-arrow {
        border-top-color: rgb(255, 255, 255);
        border-right-color: rgb(255, 255, 255);
        border-bottom-color: rgb(255, 255, 255);
        border-left-color: rgb(255, 255, 255);
      }

      .message-root-notice-close {
        color: var(--base01);
      }

      .message-root-notice-content {
        background-color: rgba(36, 41, 54, 0.8);
        color: rgb(255, 255, 255);
      }

      .message-root-custom-content-icon {
        color: rgb(255, 255, 255);
      }

      :root {
        --swiper-theme-color: var(--base0F);
      }

      .swiper-3d .swiper-slide-shadow {
        background-color: rgba(0, 0, 0, 0.15);
      }

      .swiper-lazy-preloader-white {
        --swiper-preloader-color: #fff;
      }

      .swiper-lazy-preloader-black {
        --swiper-preloader-color: #000;
      }

      .dark {
        color: rgb(238, 238, 238);
        background-color: rgb(48, 51, 54);
      }

      .dark-comment,
      .dark-quote {
        color: rgb(92, 99, 112);
      }

      .dark-doctag,
      .dark-formula,
      .dark-keyword {
        color: rgb(198, 120, 221);
      }

      .dark-deletion,
      .dark-name,
      .dark-section,
      .dark-selector-tag,
      .dark-subst {
        color: rgb(224, 108, 117);
      }

      .dark-literal {
        color: rgb(86, 182, 194);
      }

      .dark-addition,
      .dark-attribute,
      .dark-meta-string,
      .dark-regexp,
      .dark-string {
        color: rgb(152, 195, 121);
      }

      .dark-built_in,
      .dark-class .dark-title {
        color: rgb(230, 192, 123);
      }

      .dark-attr,
      .dark-number,
      .dark-selector-attr,
      .dark-selector-class,
      .dark-selector-pseudo,
      .dark-template-variable,
      .dark-type,
      .dark-variable {
        color: rgb(209, 154, 102);
      }

      .dark-bullet,
      .dark-link,
      .dark-meta,
      .dark-selector-id,
      .dark-symbol,
      .dark-title {
        color: rgb(97, 174, 238);
      }

      .dark-link {
      }

      .light {
        color: rgb(56, 58, 66);
        background-color: rgb(229, 241, 255);
      }

      .light-comment,
      .light-quote {
        color: rgb(160, 161, 167);
      }

      .light-doctag,
      .light-formula,
      .light-keyword {
        color: rgb(166, 38, 164);
      }

      .light-deletion,
      .light-name,
      .light-section,
      .light-selector-tag,
      .light-subst {
        color: rgb(228, 86, 73);
      }

      .light-literal {
        color: rgb(1, 132, 187);
      }

      .light-addition,
      .light-attribute,
      .light-meta-string,
      .light-regexp,
      .light-string {
        color: rgb(80, 161, 79);
      }

      .light-built_in,
      .light-class .light-title {
        color: rgb(193, 132, 1);
      }

      .light-attr,
      .light-number,
      .light-selector-attr,
      .light-selector-class,
      .light-selector-pseudo,
      .light-template-variable,
      .light-type,
      .light-variable {
        color: rgb(152, 104, 1);
      }

      .light-bullet,
      .light-link,
      .light-meta,
      .light-selector-id,
      .light-symbol,
      .light-title {
        color: rgb(64, 120, 242);
      }

      .splitter-layout > .layout-splitter {
        background-color: rgba(0, 0, 0, 0);
      }

      .splitter-layout.splitter-layout-vertical > .layout-splitter {
        background-color: rgba(0, 0, 0, 0);
      }

      .splitter-layout .layout-splitter-btn {
        background-color: rgb(54, 57, 60);
      }

      .splitter-layout .layout-splitter-btn:hover span {
        border-right-color: rgb(238, 238, 238);
      }

      .splitter-layout .layout-splitter-btn span {
        border-right-color: rgb(170, 174, 178);
      }

      .CodeMirror {
        color: black;
      }

      .CodeMirror-scrollbar-filler,
      .CodeMirror-gutter-filler {
        background-color: white;
      }

      .CodeMirror-gutters {
        border-right-color: rgb(221, 221, 221);
        background-color: rgb(247, 247, 247);
      }

      .CodeMirror-linenumber {
        color: rgb(153, 153, 153);
      }

      .CodeMirror-guttermarker {
        color: black;
      }

      .CodeMirror-guttermarker-subtle {
        color: rgb(153, 153, 153);
      }

      .CodeMirror-cursor {
        border-left-color: black;
      }

      .CodeMirror div.CodeMirror-secondarycursor {
        border-left-color: silver;
      }

      .cm-fat-cursor .CodeMirror-cursor {
      }

      .cm-fat-cursor .CodeMirror-cursor {
        background-color: rgb(119, 238, 119);
      }

      .cm-fat-cursor-mark {
        background-color: rgba(20, 255, 20, 0.5);
      }

      .cm-animate-fat-cursor {
        background-color: rgb(119, 238, 119);
      }

      .cm-tab {
        text-decoration-color: inherit;
      }

      .CodeMirror-ruler {
        border-left-color: rgb(204, 204, 204);
      }

      .cm-s-default .cm-header {
        color: blue;
      }

      .cm-s-default .cm-quote {
        color: rgb(0, 153, 0);
      }

      .cm-negative {
        color: rgb(221, 68, 68);
      }

      .cm-positive {
        color: rgb(34, 153, 34);
      }

      .cm-link {
      }

      .cm-strikethrough {
      }

      .cm-s-default .cm-keyword {
        color: rgb(119, 0, 136);
      }

      .cm-s-default .cm-atom {
        color: rgb(34, 17, 153);
      }

      .cm-s-default .cm-number {
        color: rgb(17, 102, 68);
      }

      .cm-s-default .cm-def {
        color: rgb(0, 0, 255);
      }

      .cm-s-default .cm-variable-2 {
        color: rgb(0, 85, 170);
      }

      .cm-s-default .cm-variable-3,
      .cm-s-default .cm-type {
        color: rgb(0, 136, 85);
      }

      .cm-s-default .cm-comment {
        color: rgb(170, 85, 0);
      }

      .cm-s-default .cm-string {
        color: rgb(170, 17, 17);
      }

      .cm-s-default .cm-string-2 {
        color: rgb(255, 85, 0);
      }

      .cm-s-default .cm-meta {
        color: rgb(85, 85, 85);
      }

      .cm-s-default .cm-qualifier {
        color: rgb(85, 85, 85);
      }

      .cm-s-default .cm-builtin {
        color: rgb(51, 0, 170);
      }

      .cm-s-default .cm-bracket {
        color: rgb(153, 153, 119);
      }

      .cm-s-default .cm-tag {
        color: rgb(17, 119, 0);
      }

      .cm-s-default .cm-attribute {
        color: rgb(0, 0, 204);
      }

      .cm-s-default .cm-hr {
        color: rgb(153, 153, 153);
      }

      .cm-s-default .cm-link {
        color: rgb(0, 0, 204);
      }

      .cm-s-default .cm-error {
        color: var(--base08);
      }

      .cm-invalidchar {
        color: var(--base08);
      }

      .CodeMirror-composing {
      }

      div.CodeMirror span.CodeMirror-matchingbracket {
        color: rgb(0, 187, 0);
      }

      div.CodeMirror span.CodeMirror-nonmatchingbracket {
        color: rgb(170, 34, 34);
      }

      .CodeMirror-matchingtag {
        background-color: rgba(255, 150, 0, 0.3);
      }

      .CodeMirror-activeline-background {
        background-color: rgb(232, 242, 255);
      }

      .CodeMirror {
        background-color: white;
      }

      .CodeMirror-scroll {
      }

      .CodeMirror-sizer {
      }

      .CodeMirror-gutter-wrapper {
        background-color: rgba(0, 0, 0, 0);
      }

      .CodeMirror-gutter-wrapper ::selection {
      }

      .CodeMirror-gutter-wrapper ::selection {
      }

      .CodeMirror-gutter-wrapper ::selection {
      }

      .CodeMirror pre.CodeMirror-line,
      .CodeMirror pre.CodeMirror-line-like {
        color: inherit;
      }

      .CodeMirror-code {
      }

      .CodeMirror-selected {
        background-color: rgb(217, 217, 217);
      }

      .CodeMirror-focused .CodeMirror-selected {
        background-color: rgb(215, 212, 240);
      }

      .CodeMirror-line::selection,
      .CodeMirror-line > span::selection,
      .CodeMirror-line > span > span::selection {
        background-color: rgb(215, 212, 240);
      }

      .CodeMirror-line::selection,
      .CodeMirror-line > span::selection,
      .CodeMirror-line > span > span::selection {
        background-color: rgb(215, 212, 240);
      }

      .CodeMirror-line::selection,
      .CodeMirror-line > span::selection,
      .CodeMirror-line > span > span::selection {
        background-color: rgb(215, 212, 240);
      }

      .cm-searching {
        background-color: rgba(255, 255, 0, 0.4);
      }

      span.CodeMirror-selectedtext {
        background-color: rgba(0, 0, 0, 0);
      }

      .cm-s-dark.CodeMirror {
        background-color: rgb(21, 23, 24);
        color: rgb(248, 248, 242);
      }

      .cm-s-dark div.CodeMirror-selected {
        background-color: rgb(73, 72, 62);
      }

      .cm-s-dark .CodeMirror-line::selection,
      .cm-s-dark .CodeMirror-line > span::selection,
      .cm-s-dark .CodeMirror-line > span > span::selection {
        background-color: rgba(73, 72, 62, 0.99);
      }

      .cm-s-dark .CodeMirror-line::selection,
      .cm-s-dark .CodeMirror-line > span::selection,
      .cm-s-dark .CodeMirror-line > span > span::selection {
        background-color: rgba(73, 72, 62, 0.99);
      }

      .cm-s-dark .CodeMirror-line::selection,
      .cm-s-dark .CodeMirror-line > span::selection,
      .cm-s-dark .CodeMirror-line > span > span::selection {
        background-color: rgba(73, 72, 62, 0.99);
      }

      .cm-s-dark .CodeMirror-gutters {
        background-color: rgb(33, 36, 38);
      }

      .cm-s-dark .CodeMirror-guttermarker {
        color: white;
      }

      .cm-s-dark .CodeMirror-guttermarker-subtle {
        color: rgb(208, 208, 208);
      }

      .cm-s-dark .CodeMirror-linenumber {
        color: rgb(208, 208, 208);
      }

      .cm-s-dark .CodeMirror-cursor {
        border-left-color: rgb(248, 248, 240);
      }

      .cm-s-dark span.cm-comment {
        color: rgb(117, 113, 94);
      }

      .cm-s-dark span.cm-atom {
        color: rgb(174, 129, 255);
      }

      .cm-s-dark span.cm-number {
        color: rgb(174, 129, 255);
      }

      .cm-s-dark span.cm-comment.cm-attribute {
        color: rgb(151, 183, 87);
      }

      .cm-s-dark span.cm-comment.cm-def {
        color: rgb(188, 146, 98);
      }

      .cm-s-dark span.cm-comment.cm-tag {
        color: rgb(188, 98, 131);
      }

      .cm-s-dark span.cm-comment.cm-type {
        color: rgb(89, 152, 166);
      }

      .cm-s-dark span.cm-property,
      .cm-s-dark span.cm-attribute {
        color: rgb(166, 226, 46);
      }

      .cm-s-dark span.cm-keyword {
        color: rgb(249, 38, 114);
      }

      .cm-s-dark span.cm-builtin {
        color: rgb(102, 217, 239);
      }

      .cm-s-dark span.cm-string {
        color: rgb(230, 219, 116);
      }

      .cm-s-dark span.cm-variable {
        color: rgb(248, 248, 242);
      }

      .cm-s-dark span.cm-variable-2 {
        color: rgb(158, 255, 255);
      }

      .cm-s-dark span.cm-variable-3,
      .cm-s-dark span.cm-type {
        color: rgb(102, 217, 239);
      }

      .cm-s-dark span.cm-def {
        color: rgb(253, 151, 31);
      }

      .cm-s-dark span.cm-bracket {
        color: rgb(248, 248, 242);
      }

      .cm-s-dark span.cm-tag {
        color: rgb(249, 38, 114);
      }

      .cm-s-dark span.cm-header {
        color: rgb(174, 129, 255);
      }

      .cm-s-dark span.cm-link {
        color: rgb(174, 129, 255);
      }

      .cm-s-dark span.cm-error {
        background-color: rgb(249, 38, 114);
        color: rgb(248, 248, 240);
      }

      .cm-s-dark .CodeMirror-lint-tooltip {
        background-color: rgb(21, 22, 22);
        border-top-color: rgb(75, 79, 82);
        border-right-color: rgb(75, 79, 82);
        border-bottom-color: rgb(75, 79, 82);
        border-left-color: rgb(75, 79, 82);
        color: rgb(238, 238, 238);
      }

      .cm-s-dark .CodeMirror-activeline-background {
        background-color: rgb(55, 56, 49);
      }

      .cm-s-dark .CodeMirror-matchingbracket {
        color: white;
      }

      .cm-s-dark .CodeMirror-matchingbracket {
      }

      .cm-s-dark .syntax-error {
        background-color: rgb(34, 35, 36);
      }

      .cm-s-light.CodeMirror {
        background-color: rgb(255, 255, 255);
        color: rgb(9, 19, 44);
      }

      .cm-s-light div.CodeMirror-selected {
        background-color: rgb(179, 188, 201);
      }

      .cm-s-light .CodeMirror-line::selection,
      .cm-s-light .CodeMirror-line > span::selection,
      .cm-s-light .CodeMirror-line > span > span::selection {
        background-color: rgba(73, 72, 62, 0.99);
      }

      .cm-s-light .CodeMirror-line::selection,
      .cm-s-light .CodeMirror-line > span::selection,
      .cm-s-light .CodeMirror-line > span > span::selection {
        background-color: rgba(73, 72, 62, 0.99);
      }

      .cm-s-light .CodeMirror-line::selection,
      .cm-s-light .CodeMirror-line > span::selection,
      .cm-s-light .CodeMirror-line > span > span::selection {
        background-color: rgba(73, 72, 62, 0.99);
      }

      .cm-s-light .CodeMirror-gutters {
        background-color: rgb(241, 242, 246);
      }

      .cm-s-light .CodeMirror-guttermarker {
        color: rgb(9, 19, 44);
      }

      .cm-s-light .CodeMirror-guttermarker-subtle {
        color: rgb(9, 19, 44);
      }

      .cm-s-light .CodeMirror-linenumber {
        color: rgb(9, 19, 44);
      }

      .cm-s-light .CodeMirror-cursor {
        border-left-color: black;
      }

      .cm-s-light span.cm-comment {
        color: rgb(170, 136, 102);
      }

      .cm-s-light span.cm-keyword {
        color: blue;
      }

      .cm-s-light span.cm-string {
        color: rgb(28, 37, 138);
      }

      .cm-s-light span.cm-builtin {
        color: rgb(0, 119, 119);
      }

      .cm-s-light span.cm-special {
        color: rgb(0, 170, 170);
      }

      .cm-s-light span.cm-variable {
        color: black;
      }

      .cm-s-light span.cm-variable-2 {
        color: rgb(230, 53, 52);
      }

      .cm-s-light span.cm-variable-3,
      .cm-s-light span.cm-type {
        color: rgb(0, 119, 119);
      }

      .cm-s-light span.cm-property,
      .cm-s-light span.cm-attribute {
        color: rgb(138, 56, 185);
      }

      .cm-s-light span.cm-number,
      .cm-s-neat span.cm-atom {
        color: rgb(51, 170, 51);
      }

      .cm-s-light span.cm-meta {
        color: rgb(85, 85, 85);
      }

      .cm-s-light span.cm-link {
        color: rgb(51, 170, 51);
      }

      .cm-s-light .CodeMirror-lint-tooltip {
        background-color: rgb(255, 255, 255);
        border-top-color: rgb(217, 218, 224);
        border-right-color: rgb(217, 218, 224);
        border-bottom-color: rgb(217, 218, 224);
        border-left-color: rgb(217, 218, 224);
        color: rgb(9, 19, 44);
      }

      .cm-s-neat .CodeMirror-activeline-background {
        background-color: rgb(232, 242, 255);
      }

      .cm-s-neat .CodeMirror-matchingbracket {
        color: black;
      }

      .cm-s-neat .CodeMirror-matchingbracket {
        outline-color: grey;
      }

      .cm-s-light .syntax-error {
        background-color: rgb(242, 246, 250);
      }

      .CodeMirror-lint-tooltip {
        background-color: rgb(255, 255, 221);
        border-top-color: black;
        border-right-color: black;
        border-bottom-color: black;
        border-left-color: black;
        color: black;
      }

      .swiper-button-prev,
      .swiper-button-next {
        color: var(--swiper-navigation-color, var(--swiper-theme-color));
      }

      .swiper-pagination-bullet {
      }

      button.swiper-pagination-bullet {
      }

      .swiper-pagination-bullet-active {
      }

      .swiper-pagination-fraction {
        color: var(--swiper-pagination-fraction-color, inherit);
      }

      .swiper-pagination-progressbar {
      }

      .swiper-pagination-progressbar .swiper-pagination-progressbar-fill {
      }

      .jss221 {
        color: var(--base0F);
      }

      .jss211 {
      }

      .jss72 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss83 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss115 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss137 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss161 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss219 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss247 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss253 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss389 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss394 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss415 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss475 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss495 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss505 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss519 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss575 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss584 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss587 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss590 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss594 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss603 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss636 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss660 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss681 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss717 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss723 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss735 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss825 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss930 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss932 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss934 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss939 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss956 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss976 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss984 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss1002 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss1031 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss1037 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss1057 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss1062 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss1064 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss1066 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss1071 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss1133 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss1135 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss1137 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss1139 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss1141 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss1143 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss1204 {
        color: rgb(255, 255, 255);
        background-color: rgb(65, 65, 65);
      }

      .jss339 {
        color: rgb(163, 163, 163);
      }

      .jss340:hover {
        color: rgb(242, 242, 242);
      }

      .jss344 {
        color: rgb(170, 174, 178);
        background-color: rgb(34, 35, 36);
      }

      .jss344::after {
        border-top-color: rgb(79, 79, 79);
        border-right-color: rgb(79, 79, 79);
        border-bottom-color: rgb(79, 79, 79);
        border-left-color: rgb(79, 79, 79);
      }

      .jss344:hover {
        color: rgb(238, 238, 238);
      }

      .jss345 {
        color: rgb(170, 174, 178);
        background-color: rgb(34, 35, 36);
      }

      .jss345::after {
        border-top-color: rgb(79, 79, 79);
        border-right-color: rgb(79, 79, 79);
        border-bottom-color: rgb(79, 79, 79);
        border-left-color: rgb(79, 79, 79);
      }

      .jss346 {
        color: var(--base0F);
        background-color: rgba(4, 157, 250, 0.15);
      }

      .jss346::after {
        border-top-color: var(--base0F);
        border-right-color: var(--base0F);
        border-bottom-color: var(--base0F);
        border-left-color: var(--base0F);
      }

      .jss346:hover {
        color: var(--base0F);
      }

      .jss183 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss314 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss338 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss380 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss635 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss659 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss680 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss716 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss722 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss734 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss756 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss863 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss908 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss937 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss954 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss974 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss1000 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss1146 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss500 .simplebar-scrollbar::before {
        background-color: rgb(82, 82, 82);
      }

      .jss500 .simplebar-hover .simplebar-scrollbar::before {
        background-color: rgb(97, 97, 97);
      }

      .jss757 .simplebar-scrollbar::before {
        background-color: rgb(82, 82, 82);
      }

      .jss757 .simplebar-hover .simplebar-scrollbar::before {
        background-color: rgb(97, 97, 97);
      }

      .jss1148 .simplebar-scrollbar::before {
        background-color: rgb(82, 82, 82);
      }

      .jss1148 .simplebar-hover .simplebar-scrollbar::before {
        background-color: rgb(97, 97, 97);
      }

      .jss1206 .simplebar-scrollbar::before {
        background-color: rgb(82, 82, 82);
      }

      .jss1206 .simplebar-hover .simplebar-scrollbar::before {
        background-color: rgb(97, 97, 97);
      }

      .jss1208 .simplebar-scrollbar::before {
        background-color: rgb(82, 82, 82);
      }

      .jss1208 .simplebar-hover .simplebar-scrollbar::before {
        background-color: rgb(97, 97, 97);
      }

      .jss759 .simplebar-scrollbar::before {
        background-color: rgb(82, 82, 82);
      }

      .jss759 .simplebar-hover .simplebar-scrollbar::before {
        background-color: rgb(97, 97, 97);
      }

      .jss1149 .simplebar-scrollbar::before {
        background-color: rgb(82, 82, 82);
      }

      .jss1149 .simplebar-hover .simplebar-scrollbar::before {
        background-color: rgb(97, 97, 97);
      }

      .jss1207 .simplebar-scrollbar::before {
        background-color: rgb(82, 82, 82);
      }

      .jss1207 .simplebar-hover .simplebar-scrollbar::before {
        background-color: rgb(97, 97, 97);
      }

      .jss1209 .simplebar-scrollbar::before {
        background-color: rgb(82, 82, 82);
      }

      .jss1209 .simplebar-hover .simplebar-scrollbar::before {
        background-color: rgb(97, 97, 97);
      }

      .jss864 {
        color: rgb(242, 242, 242);
      }

      .jss864:hover {
        color: rgb(242, 242, 242);
      }

      .jss865,
      .jss865:hover {
        color: rgb(97, 97, 97);
      }

      .jss315 {
        color: rgb(242, 242, 242);
        border-top-color: rgb(65, 65, 65);
        border-right-color: rgb(65, 65, 65);
        border-bottom-color: rgb(65, 65, 65);
        border-left-color: rgb(65, 65, 65);
      }

      .jss315:hover {
        border-top-color: var(--base02);
        border-right-color: var(--base02);
        border-bottom-color: var(--base02);
        border-left-color: var(--base02);
      }

      .jss317,
      .jss317:hover {
        color: rgb(97, 97, 97);
        border-top-color: rgb(65, 65, 65);
        border-right-color: rgb(65, 65, 65);
        border-bottom-color: rgb(65, 65, 65);
        border-left-color: rgb(65, 65, 65);
        background-color: rgb(65, 65, 65);
      }

      .jss318,
      .jss318:hover {
        border-top-color: var(--base0F);
        border-right-color: var(--base0F);
        border-bottom-color: var(--base0F);
        border-left-color: var(--base0F);
      }

      .jss321 {
        color: var(--base0F);
      }

      .jss16 {
      }

      .jss17 {
      }

      .jss20 {
        border-bottom-color: var(--base00);
        background-color: var(--base01);
      }

      .jss22 {
        color: rgb(163, 163, 163);
      }

      .jss22:hover {
        color: rgb(242, 242, 242);
      }

      .jss23 {
        background-color: var(--base00);
      }

      .jss26 {
        border-top-color: var(--base01);
      }

      .jss34 {
        color: rgb(242, 242, 242);
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss200 {
        color: rgb(242, 242, 242);
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss250 {
        color: rgb(242, 242, 242);
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss267 {
        color: rgb(242, 242, 242);
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss165 {
        color: rgb(242, 242, 242);
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss172 {
        color: rgb(235, 157, 46);
        background-color: rgb(74, 51, 19);
      }

      .jss199 {
        color: var(--base0B);
        background-color: rgb(18, 66, 52);
      }

      .jss351 {
        color: var(--base0B);
        background-color: rgb(18, 66, 52);
      }

      .jss352 {
        color: var(--base0B);
        background-color: rgb(18, 66, 52);
      }

      .jss498 {
        color: var(--base0B);
        background-color: rgb(18, 66, 52);
      }

      .jss606 {
        color: var(--base0B);
        background-color: rgb(18, 66, 52);
      }

      .jss639 {
        color: var(--base0B);
        background-color: rgb(18, 66, 52);
      }

      .jss663 {
        color: var(--base0B);
        background-color: rgb(18, 66, 52);
      }

      .jss684 {
        color: var(--base0B);
        background-color: rgb(18, 66, 52);
      }

      .jss720 {
        color: var(--base0B);
        background-color: rgb(18, 66, 52);
      }

      .jss726 {
        color: var(--base0B);
        background-color: rgb(18, 66, 52);
      }

      .jss738 {
        color: var(--base0B);
        background-color: rgb(18, 66, 52);
      }

      .jss902 {
        color: var(--base0B);
        background-color: rgb(18, 66, 52);
      }

      .jss903 {
        color: var(--base0B);
        background-color: rgb(18, 66, 52);
      }

      .jss904 {
        color: rgb(235, 157, 46);
        background-color: rgb(74, 51, 19);
      }

      .jss909 {
        color: var(--base0B);
        background-color: rgb(18, 66, 52);
      }

      .jss910 {
        color: var(--base0B);
        background-color: rgb(18, 66, 52);
      }

      .jss959 {
        color: var(--base0B);
        background-color: rgb(18, 66, 52);
      }

      .jss1147 {
        color: rgb(235, 157, 46);
        background-color: rgb(74, 51, 19);
      }

      .jss874 {
        background-color: rgba(0, 0, 0, 0.6);
      }

      .jss878 {
        border-top-color: rgba(0, 0, 0, 0.4);
        border-right-color: rgba(0, 0, 0, 0.4);
        border-bottom-color: rgba(0, 0, 0, 0.4);
        border-left-color: rgba(0, 0, 0, 0.4);
        background-color: rgba(255, 255, 255, 0.4);
      }

      .jss878:hover {
        background-color: rgba(255, 255, 255, 0.5);
      }

      .jss880 {
        color: rgb(242, 242, 242);
        background-color: var(--base00);
      }

      .jss884 {
        border-bottom-color: var(--base00);
      }

      .jss885 {
        color: rgba(0, 0, 0, 0.4);
      }

      .jss980 {
        border-bottom-color: var(--base00);
      }

      .jss981 {
        color: rgba(0, 0, 0, 0.4);
      }

      .jss140 {
        color: rgb(242, 242, 242);
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss144 {
        color: rgb(242, 242, 242);
      }

      .jss145 {
        border-top-color: var(--base01);
        background-color: var(--base00);
      }

      .jss148 {
        border-bottom-color: var(--base00);
        background-color: var(--base01);
      }

      .jss497 {
        border-bottom-color: var(--base00);
        background-color: var(--base01);
      }

      .jss605 {
        border-bottom-color: var(--base00);
        background-color: var(--base01);
      }

      .jss268 {
        background-color: var(--base00);
      }

      .jss507 {
        background-color: rgba(0, 0, 0, 0);
      }

      .jss510 {
        color: rgb(170, 174, 178);
      }

      .jss511 {
        color: rgb(242, 242, 242);
      }

      .jss511::before {
        background-color: var(--base01);
      }

      .jss511::after {
        border-right-color: var(--base01);
        border-bottom-color: var(--base01);
        background-color: var(--base01);
      }

      .jss512 {
        background-color: var(--base01);
      }

      .jss514 {
        background-color: rgba(0, 0, 0, 0);
      }

      .jss517 {
        color: var(--base0B);
      }

      .jss518 {
        color: var(--base08);
      }

      .jss100::after {
        border-top-color: var(--base01);
        border-right-color: var(--base01);
        border-bottom-color: var(--base01);
        border-left-color: var(--base01);
      }

      .jss106::after {
        border-top-color: var(--base00);
        border-right-color: var(--base00);
        border-bottom-color: var(--base00);
        border-left-color: var(--base00);
      }

      .jss107::after {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
      }

      .jss108::after {
        border-top-color: rgba(41, 41, 41, 0.7);
        border-right-color: rgba(41, 41, 41, 0.7);
        border-bottom-color: rgba(41, 41, 41, 0.7);
        border-left-color: rgba(41, 41, 41, 0.7);
      }

      .jss502 {
        background-color: var(--base00);
      }

      .jss503 {
        color: rgb(170, 174, 178);
      }

      .jss504 {
        color: rgb(163, 163, 163);
      }

      .jss36 {
        color: var(--base0F);
      }

      .jss37 {
      }

      .jss38 {
        border-top-color: var(--base01);
        border-right-color: var(--base01);
        border-bottom-color: var(--base01);
        border-left-color: var(--base01);
        background-color: var(--base00);
      }

      .jss39 {
        color: rgb(242, 242, 242);
      }

      .jss40 {
        color: rgb(163, 163, 163);
      }

      .jss40 p {
        color: rgb(163, 163, 163);
      }

      .jss40 li {
        color: rgb(163, 163, 163);
      }

      .jss40 h2 {
        color: rgb(163, 163, 163);
      }

      .jss40 a {
        color: var(--base0F);
      }

      .jss43 {
        color: rgb(163, 163, 163);
      }

      .jss43 i {
      }

      .jss43 > p {
        color: var(--base0F);
      }

      .jss43 i:hover {
        color: rgb(6, 143, 227);
      }

      .jss44 {
        color: rgb(163, 163, 163);
      }

      .jss46 {
        color: rgb(255, 255, 255);
        background-color: rgb(13, 134, 255);
      }

      .jss47 {
        border-bottom-color: rgba(199, 203, 209, 0.3);
      }

      .jss47 > input {
        background-color: var(--base00);
      }

      .jss47 > input::placeholder {
        color: rgb(97, 97, 97);
      }

      .jss48 {
        color: rgb(163, 163, 163);
      }

      .jss63 {
        color: rgb(255, 255, 255);
      }

      .jss63::before {
        background-color: var(--base0F);
      }

      .jss63::after {
        background-color: var(--base0F);
      }

      .jss64::after {
        border-top-color: var(--base0F);
        border-right-color: var(--base0F);
      }

      .jss65::after {
        border-left-color: var(--base0F);
        border-bottom-color: var(--base0F);
      }

      .jss66::after {
        border-top-color: var(--base0F);
        border-left-color: var(--base0F);
      }

      .jss67::after {
        border-right-color: var(--base0F);
        border-bottom-color: var(--base0F);
      }

      .jss1047 {
        color: rgb(163, 163, 163);
        background-color: var(--base00);
      }

      .jss1047::after {
        border-top-color: rgb(65, 65, 65);
        border-right-color: rgb(65, 65, 65);
        border-bottom-color: rgb(65, 65, 65);
        border-left-color: rgb(65, 65, 65);
      }

      .jss1048 {
        color: rgb(242, 242, 242);
      }

      .jss1048:hover {
        color: rgb(242, 242, 242);
        background-color: var(--base02);
      }

      .jss1048:hover > i {
        color: rgb(242, 242, 242);
      }

      .jss1049 {
        color: rgb(255, 255, 255);
        background-color: var(--base0F);
      }

      .jss1050 {
        color: rgb(242, 242, 242);
      }

      .jss1051:hover {
        color: rgb(255, 255, 255);
      }

      .jss1052 {
        color: rgb(125, 125, 125);
      }

      .jss1052:hover {
        color: rgb(163, 163, 163);
      }

      .jss1053 {
        color: rgb(27, 194, 255);
      }

      .jss1053:hover {
        color: rgb(27, 194, 255);
      }

      .jss1055 {
        background-color: rgba(0, 0, 0, 0);
      }

      .jss1055:hover {
        color: rgb(2, 206, 236);
      }

      .jss1056 {
        color: rgb(242, 242, 242);
        background-color: rgba(2, 206, 236, 0.15);
      }

      .jss1056 > i {
        color: rgb(2, 206, 236);
      }

      .driver-popover {
        color: rgb(255, 255, 255);
        background-color: var(--base0F);
      }

      .driver-popover .driver-popover-close-btn {
        color: rgba(255, 255, 255, 0.7);
      }

      .driver-popover .driver-popover-arrow-side-left.driver-popover-arrow {
        border-left-color: var(--base0F);
      }

      .driver-popover .driver-popover-arrow-side-right.driver-popover-arrow {
        border-right-color: var(--base0F);
      }

      .driver-popover .driver-popover-arrow-side-top.driver-popover-arrow {
        border-top-color: var(--base0F);
      }

      .driver-popover .driver-popover-arrow-side-bottom.driver-popover-arrow {
        border-bottom-color: var(--base0F);
      }

      .driver-popover .driver-popover-progress-text {
        color: rgb(255, 255, 255);
      }

      .driver-popover .driver-popover-footer button {
        color: rgb(255, 255, 255);
        border-top-color: rgba(255, 255, 255, 0.3);
        border-right-color: rgba(255, 255, 255, 0.3);
        border-bottom-color: rgba(255, 255, 255, 0.3);
        border-left-color: rgba(255, 255, 255, 0.3);
        background-color: rgba(255, 255, 255, 0.1);
      }

      .driver-popover .driver-popover-footer button:hover {
        border-top-color: rgba(255, 255, 255, 0.3);
        border-right-color: rgba(255, 255, 255, 0.3);
        border-bottom-color: rgba(255, 255, 255, 0.3);
        border-left-color: rgba(255, 255, 255, 0.3);
        background-color: rgba(255, 255, 255, 0.3);
      }

      .driver-popover .driver-popover-close-btn:hover {
        color: rgb(255, 255, 255);
      }

      .driver-active .driver-active-element[data-guideId="market-guide1"],
      .driver-active .driver-active-element[data-guideId="market-guide2"],
      .driver-active .driver-active-element[data-guideId="market-guide3"],
      .driver-active .driver-active-element[data-guideId="market-guide4"] {
        border-top-color: rgb(127, 171, 255);
        border-right-color: rgb(127, 171, 255);
        border-bottom-color: rgb(127, 171, 255);
        border-left-color: rgb(127, 171, 255);
      }

      .driver-active .driver-active-element[data-guideId="module-guide1"]::before,
      .driver-active .driver-active-element[data-guideId="module-guide3"]::before {
        border-top-color: rgb(127, 171, 255);
        border-right-color: rgb(127, 171, 255);
        border-bottom-color: rgb(127, 171, 255);
        border-left-color: rgb(127, 171, 255);
      }

      .jss216 {
        color: rgb(125, 125, 125);
      }

      .jss216:hover {
        color: rgb(163, 163, 163);
      }

      .jss246 {
        color: rgb(125, 125, 125);
      }

      .jss246:active {
        color: rgb(2, 206, 236);
      }

      .jss246:hover {
        color: rgb(255, 255, 255);
      }

      .jss1185 {
        color: rgb(125, 125, 125);
      }

      .jss1187 {
        background-color: rgba(0, 0, 0, 0);
      }

      .jss1188 {
        color: rgb(163, 163, 163);
      }

      .jss1188 a {
        color: var(--base0F);
      }

      .jss188 {
        border-top-color: rgb(65, 65, 65);
        border-right-color: rgb(65, 65, 65);
        border-bottom-color: rgb(65, 65, 65);
        border-left-color: rgb(65, 65, 65);
      }

      .jss188 > .jss190 {
        border-top-color: rgb(65, 65, 65);
        border-right-color: rgb(65, 65, 65);
        border-bottom-color: rgb(65, 65, 65);
        border-left-color: rgb(65, 65, 65);
      }

      .jss188 .jss189 {
        color: rgb(125, 125, 125);
      }

      .jss188:has(input:disabled) {
        color: rgb(125, 125, 125);
        border-top-color: rgb(65, 65, 65);
        border-right-color: rgb(65, 65, 65);
        border-bottom-color: rgb(65, 65, 65);
        border-left-color: rgb(65, 65, 65);
        background-color: var(--base00);
      }

      .jss188:has(input:focus),
      .jss188:has(input:focus) > .jss190 {
        border-top-color: var(--base0F);
        border-right-color: var(--base0F);
        border-bottom-color: var(--base0F);
        border-left-color: var(--base0F);
      }

      .jss188:hover,
      .jss188:hover > .jss190 {
        border-top-color: var(--base02);
        border-right-color: var(--base02);
        border-bottom-color: var(--base02);
        border-left-color: var(--base02);
      }

      .jss188 > .jss190 > input {
        caret-color: var(--base0F);
      }

      .jss190 {
        color: rgb(242, 242, 242);
      }

      .jss190 > input {
        color: rgb(242, 242, 242);
      }

      .jss191 > button {
        color: rgb(125, 125, 125);
        background-color: var(--base00);
      }

      .jss191 > button:hover {
        color: rgb(163, 163, 163);
        background-color: var(--base00);
      }

      .jss301 {
        background-color: var(--base01);
      }

      .jss301::after {
        border-bottom-color: var(--base00);
      }

      .jss302 {
        background-color: var(--base01);
      }

      .jss303 {
        color: rgb(163, 163, 163);
      }

      .jss303:hover {
        color: rgb(242, 242, 242);
        background-color: var(--base00);
      }

      .jss303:first-child {
      }

      .jss304::after {
        background-color: var(--base00);
      }

      .jss305 {
        border-top-color: var(--base00);
        border-right-color: var(--base00);
        border-left-color: var(--base00);
        background-color: var(--base02);
      }

      .jss305::before {
        display: none;

      }

      .jss305::after {
        display: none;
      }

      .jss305 > span {
        color: rgb(242, 242, 242);
      }

      .jss305:hover {
        background-color: var(--base02);
      }

      .jss81 {
        color: rgb(163, 163, 163);
      }

      .jss81:active {
        color: rgb(238, 238, 238);
      }

      .jss81:hover {
        color: rgb(242, 242, 242);
      }

      .jss126 {
        border-top-color: var(--base02);
        border-right-color: var(--base02);
        border-bottom-color: var(--base02);
        border-left-color: var(--base02);
      }

      .jss127 {
        color: rgb(163, 163, 163);
      }

      .jss127:hover {
        color: rgb(242, 242, 242);
      }

      .jss159 {
        color: rgb(242, 242, 242);
      }

      .jss262 {
        background-color: var(--base01);
      }

      .jss263 {
        border-bottom-color: var(--base01);
        background-color: var(--base01);
      }

      .jss579 {
        color: rgb(242, 242, 242);
      }

      .jss252 {
        color: rgb(125, 125, 125);
      }

      .jss252:hover {
        color: rgb(255, 255, 255);
      }

      .jss213 {
        border-right-color: rgb(47, 49, 53);
        background-color: var(--base01);
      }

      .jss4 {
        color: rgb(255, 255, 255);
        background-color: var(--base01);
      }

      .jss5 {
        color: rgb(138, 141, 145);
      }

      .jss9 {
        color: rgb(242, 242, 242);
      }

      .jss10 {
        color: rgb(163, 163, 163);
      }

      .jss12 {
        color: rgb(242, 242, 242);
      }

      .jss15 {
        color: rgb(97, 97, 97);
      }

      .jss197 > span {
        color: var(--base0F);
      }

      .jss197 > i {
        color: var(--base0F);
      }

      .jss198 {
        background-color: rgba(0, 0, 0, 0);
      }

      .jss607 {
        border-top-color: rgb(47, 49, 53);
      }

      .jss608 {
        background-color: rgba(255, 255, 255, 0.2);
      }

      .jss610 {
        color: rgb(255, 255, 255);
      }

      .jss613 {
        color: rgb(255, 255, 255);
      }

      .jss614 {
        color: var(--base0F);
      }

      .jss614 > i {
        color: var(--base0F);
      }

      .jss130::after {
        background-color: var(--base02);
      }

      .jss132 {
        border-right-color: var(--base01);
      }

      .jss135 {
        color: rgb(163, 163, 163);
      }

      .jss135:active {
        color: rgb(238, 238, 238);
      }

      .jss135:hover {
        color: rgb(242, 242, 242);
      }

      .jss174 {
        background-color: var(--base01);
      }

      .jss175 {
        color: rgb(163, 163, 163);
      }

      .jss176 {
        color: rgb(163, 163, 163);
      }

      .jss176:hover {
        color: rgb(242, 242, 242);
      }

      .jss1027 {
        color: rgb(242, 242, 242);
      }

      .jss193 {
        color: rgb(242, 242, 242);
      }

      .jss194 {
        border-top-color: var(--base02);
        border-right-color: var(--base02);
        border-bottom-color: var(--base02);
        border-left-color: var(--base02);
      }

      .jss667 {
        color: var(--base0F);
      }

      .jss668 {
        color: rgb(138, 141, 145);
      }

      .jss669 {
        color: rgb(125, 125, 125);
      }

      .jss61 {
        background-color: rgb(220, 31, 78);
      }

      .jss82 {
        background-color: rgb(220, 31, 78);
      }

      .jss160 {
        background-color: rgb(220, 31, 78);
      }

      .jss986 {
        background-color: rgb(220, 31, 78);
      }

      .jss58 {
        color: rgb(163, 163, 163);
      }

      .jss58:active {
        color: rgb(238, 238, 238);
      }

      .jss58:hover {
        color: rgb(242, 242, 242);
      }

      .jss1197 {
        border-top-color: rgb(82, 82, 82);
        border-right-color: rgb(82, 82, 82);
        border-bottom-color: rgb(82, 82, 82);
        border-left-color: rgb(82, 82, 82);
        background-color: var(--base00);
      }

      .jss1199 {
        color: rgb(242, 242, 242);
      }

      .jss1200 {
        color: rgb(242, 242, 242);
      }

      .jss86 {
        background-color: rgba(251, 144, 29, 0.15);
      }

      .jss87 {
        color: rgb(242, 242, 242);
        background-color: var(--base01);
      }

      .jss120 {
        color: rgb(242, 242, 242);
      }

      .jss120 a {
        color: var(--base0F);
      }

      .jss121 {
        color: rgb(163, 163, 163);
      }

      .jss121:active {
        color: rgb(242, 242, 242);
      }

      .jss121:hover {
        color: rgb(242, 242, 242);
      }

      .jss123 {
      }

      .jss124 strong {
        color: rgb(242, 242, 242);
      }

      .jss124 li,
      .jss124 p {
        color: rgb(163, 163, 163);
      }

      .jss201 {
        color: rgb(163, 163, 163);
        background-color: var(--base01);
      }

      .jss110 {
        color: rgb(163, 163, 163);
      }

      .jss110:hover {
        color: rgb(242, 242, 242);
      }

      .jss111 {
        color: rgb(255, 255, 255);
        background-color: var(--base0F);
      }

      .jss111::after {
        border-top-color: var(--base0F);
        border-left-color: var(--base0F);
      }

      .jss112 {
        color: rgb(255, 255, 255);
        background-color: var(--base0F);
      }

      .jss112::before {
        border-bottom-color: var(--base0F);
      }

      .jss112::after {
      }

      .jss114 {
        color: rgb(163, 163, 163);
      }

      .jss114:active {
        color: rgb(242, 242, 242);
      }

      .jss114:hover {
        color: rgb(242, 242, 242);
      }

      .jss56 {
        background-color: var(--base02);
      }

      .jss1178 {
        color: var(--base0B);
        background-color: rgba(7, 205, 165, 0.1);
      }

      .jss1179 {
        color: var(--base08);
        background-color: rgba(250, 51, 100, 0.1);
      }

      .jss1180 {
        color: var(--base0F);
        background-color: rgba(4, 157, 250, 0.1);
      }

      .jss1181 {
        color: rgb(242, 93, 49);
        background-color: rgba(242, 93, 49, 0.1);
      }

      .jss1035 {
      }

      .jss577 {
        color: rgb(125, 125, 125);
      }

      .jss381 {
        color: rgb(163, 163, 163);
      }

      .jss381:hover {
        color: rgb(242, 242, 242);
      }

      .jss387 {
        color: var(--base0F);
      }

      .jss387:hover {
        color: var(--base0F);
      }

      .jss370 {
        color: rgb(242, 242, 242);
        background-color: var(--base00);
      }

      .jss1005 {
        color: rgb(170, 174, 178);
      }

      .jss1006 * {
        color: var(--base0F);
      }

      .jss1006 :hover {
        color: var(--base0F);
      }

      .jss1009 {
        color: rgb(2, 206, 236);
        background-color: rgba(2, 206, 236, 0.15);
      }

      .jss1015:hover {
        color: rgb(242, 242, 242);
        background-color: var(--base02);
      }

      .jss1018 {
        color: rgb(242, 242, 242);
      }

      .jss1019 {
        color: rgb(125, 125, 125);
      }

      .jss1020 {
        background-color: var(--base00);
      }

      .jss943 * {
        color: var(--base0F);
      }

      .jss943 :hover {
        color: var(--base0F);
      }

      .jss945 * {
        color: rgb(97, 97, 97);
      }

      .jss945 :hover {
        color: rgb(97, 97, 97);
      }

      .jss948 {
        color: var(--base0F);
        background-color: rgba(4, 157, 250, 0.15);
      }

      .jss979 img {
        background-color: rgb(127, 171, 255);
      }

      .jss979 .info {
        background-color: var(--base00);
      }

      .jss979 h1 {
        color: rgb(255, 255, 255);
      }

      .jss979 p {
        color: rgb(255, 255, 255);
      }

      .jss961 * {
        color: var(--base0F);
      }

      .jss961 :hover {
        color: var(--base0F);
      }

      .jss970 {
        color: rgb(255, 255, 255);
        background-color: var(--base0F);
      }

      .jss970::after {
        border-top-color: var(--base0F);
        border-left-color: var(--base0F);
      }

      .jss971 {
        color: rgba(255, 255, 255, 0.8);
      }

      .jss971:hover {
        color: rgb(255, 255, 255);
      }

      .jss972 {
        border-top-color: var(--base01);
        border-right-color: var(--base01);
        border-bottom-color: var(--base01);
        border-left-color: var(--base01);
        background-color: rgb(251, 72, 116);
      }

      .jss392 {
        border-top-color: var(--base01);
        border-right-color: var(--base01);
        border-bottom-color: var(--base01);
        border-left-color: var(--base01);
        background-color: rgb(251, 72, 116);
      }

      .jss989 * {
        color: var(--base0F);
      }

      .jss989 :hover {
        color: var(--base0F);
      }

      .jss994 {
      }

      .jss994:hover {
      }

      .jss371 {
        border-bottom-color: rgb(65, 65, 65);
      }

      .jss373 {
        background-color: rgb(65, 65, 65);
      }

      .jss374 {
        background-color: var(--base02);
      }

      .jss376 {
        color: rgb(163, 163, 163);
      }

      .jss982 {
        color: rgb(163, 163, 163);
      }

      .jss982:hover {
        color: rgb(242, 242, 242);
      }

      .jss790 {
        color: rgb(255, 159, 9);
      }

      .jss790:hover {
        color: rgb(255, 159, 9);
      }

      .jss791 {
        color: rgb(255, 159, 9);
      }

      .jss791:hover {
        color: rgb(255, 159, 9);
      }

      .jss894 {
        color: rgb(163, 163, 163);
      }

      .jss894:hover {
        color: rgb(242, 242, 242);
      }

      .jss927 {
        color: rgb(163, 163, 163);
      }

      .jss928 {
        color: rgb(163, 163, 163);
      }

      .jss929 {
        color: var(--base0F);
      }

      .jss873 {
        border-top-color: var(--base00);
        border-right-color: var(--base00);
        border-bottom-color: var(--base00);
        border-left-color: var(--base00);
        background-color: var(--base00);
      }

      .jss837 {
        color: rgb(163, 163, 163);
      }

      .jss838 {
        color: rgb(255, 207, 0);
      }

      .jss841 {
        color: var(--base0F);
      }

      .jss842 {
        color: rgb(163, 163, 163);
        background-color: var(--base01);
      }

      .jss842::after {
        border-top-color: rgb(79, 79, 79);
        border-right-color: rgb(79, 79, 79);
        border-bottom-color: rgb(79, 79, 79);
        border-left-color: rgb(79, 79, 79);
      }

      .jss842:hover {
        color: rgb(242, 242, 242);
      }

      .jss846 {
        color: var(--base0F);
      }

      .jss846::after {
        background-color: var(--base0F);
      }

      .jss847 {
        color: rgb(163, 163, 163);
      }

      .jss850 {
        color: rgb(163, 163, 163);
      }

      .jss855 {
        border-right-color: rgba(216, 216, 216, 0.2);
      }

      .jss856 {
      }

      .jss858 {
        color: rgb(242, 242, 242);
      }

      .jss858::before {
        background-color: var(--base01);
      }

      .jss860 {
        color: var(--base0F);
      }

      .jss860::after {
        background-color: var(--base0F);
      }

      .jss911 {
        color: rgb(242, 242, 242);
      }

      .jss912 {
        background-color: rgb(21, 23, 24);
        border-left-color: var(--base02);
        border-bottom-color: var(--base02);
      }

      .jss913 {
        border-top-color: var(--base02);
        border-right-color: var(--base02);
        border-bottom-color: var(--base02);
        border-left-color: var(--base02);
        background-color: rgb(21, 23, 24);
      }

      .jss915.active {
        background-color: rgb(57, 61, 65);
      }

      .jss915:hover {
        background-color: rgb(18, 34, 43);
      }

      .jss916 {
        background-color: rgb(21, 23, 24);
        border-top-color: var(--base02);
        border-bottom-color: var(--base02);
      }

      .jss916 > span {
        color: rgb(163, 163, 163);
      }

      .jss917 {
        border-top-color: var(--base02);
      }

      .jss1091 {
        color: rgb(13, 183, 135);
      }

      .jss1092 {
        color: rgb(220, 31, 78);
      }

      .jss1093 {
        color: rgb(242, 242, 242);
      }

      .jss1131 {
        color: rgba(138, 141, 145, 0.5);
      }

      .jss1115 {
        background-color: var(--base01);
      }

      .jss1116 {
        color: rgba(138, 141, 145, 0.5);
      }

      .jss1117 {
        color: rgb(170, 174, 178);
      }

      .jss1117:hover {
        color: rgb(238, 238, 238);
        background-color: rgb(18, 34, 43);
      }

      .jss1118 {
        background-color: rgb(57, 61, 65);
      }

      .jss1121 {
        color: rgb(242, 242, 242);
      }

      .jss1121:hover {
        color: rgb(242, 242, 242);
        background-color: rgb(18, 34, 43);
      }

      .jss1122 {
        background-color: rgb(63, 137, 255);
      }

      .jss1127 {
        background-color: var(--base01);
      }

      .jss1130 {
        color: rgb(238, 238, 238);
        background-color: rgba(94, 98, 98, 0.8);
      }

      .jss1130:hover {
        background-color: rgb(94, 98, 98);
      }

      .jss1110 {
        background-color: rgb(7, 206, 236);
      }

      .jss1111 {
        background-color: rgba(7, 206, 236, 0.4);
      }

      .jss828 {
        color: rgb(125, 125, 125);
      }

      .jss833 {
        color: rgb(39, 41, 42);
      }

      .jss834 {
        border-bottom-color: var(--base00);
      }

      .jss835 {
        border-top-color: rgb(65, 65, 65);
      }

      .jss747 {
        color: rgb(125, 125, 125);
      }

      .jss752 {
        color: rgb(39, 41, 42);
      }

      .jss753 {
        border-bottom-color: var(--base00);
      }

      .jss754 {
        border-top-color: rgb(65, 65, 65);
      }

      .jss150 {
        color: rgb(163, 163, 163);
      }

      .jss150 button {
      }

      .jss150 svg {
        color: rgb(163, 163, 163);
      }

      .jss150 svg:hover {
        color: rgb(242, 242, 242);
      }

      .jss150 button:disabled svg,
      .jss150 button:disabled svg:hover {
        color: rgb(97, 97, 97);
      }

      .jss593 {
        color: rgb(163, 163, 163);
      }

      .jss593:hover {
        color: rgb(242, 242, 242);
      }

      .jss49 {
        background-color: var(--base00);
      }

      .jss55 {
        background-color: rgba(0, 0, 0, 0);
      }

      .jss400 {
        color: rgb(242, 242, 242);
      }

      .jss401 {
        color: var(--base0B);
      }

      .jss402 {
        color: var(--base08);
      }

      .jss403 {
        color: rgb(242, 242, 242);
      }

      .jss404 {
        background-color: rgba(0, 0, 0, 0);
      }

      .jss404:hover {
        color: rgb(170, 174, 178);
      }

      .jss406 {
        color: rgb(163, 163, 163);
        background-color: var(--base01);
      }

      .jss479 {
        border-top-color: rgb(65, 65, 65);
        border-right-color: rgb(65, 65, 65);
        border-bottom-color: rgb(65, 65, 65);
        border-left-color: rgb(65, 65, 65);
      }

      .jss480 {
        color: rgb(163, 163, 163);
      }

      .jss481 {
        color: rgb(163, 163, 163);
      }

      .jss482::after {
        border-top-color: rgb(65, 65, 65);
        border-right-color: rgb(65, 65, 65);
        border-bottom-color: rgb(65, 65, 65);
        border-left-color: rgb(65, 65, 65);
      }

      .jss483 {
        color: rgb(242, 242, 242);
      }

      .jss483.active {
        background-color: rgb(57, 61, 65);
      }

      .jss483:hover {
        background-color: rgb(18, 34, 43);
      }

      .jss490 {
        color: rgb(242, 242, 242);
      }

      .jss491 {
        color: rgb(163, 163, 163);
      }

      .jss493 {
        color: rgb(255, 255, 255);
        background-color: var(--base0F);
      }

      .jss493::after {
        border-top-color: var(--base0F);
        border-left-color: var(--base0F);
      }

      .jss494 {
        color: rgba(255, 255, 255, 0.8);
      }

      .jss494:hover {
        color: rgb(255, 255, 255);
      }

      .jss628 {
        border-top-color: var(--base00);
        background-color: var(--base01);
      }

      .jss630 {
        color: rgb(242, 242, 242);
      }

      .jss631 {
        border-bottom-color: var(--base00);
      }

      .jss632 {
        color: rgb(163, 163, 163);
      }

      .jss633 {
        color: var(--base0F);
      }

      .jss690 {
        color: rgb(242, 242, 242);
      }

      .jss690::after {
        border-top-color: rgb(65, 65, 65);
        border-right-color: rgb(65, 65, 65);
        border-bottom-color: rgb(65, 65, 65);
        border-left-color: rgb(65, 65, 65);
      }

      .jss695::after {
        border-top-color: rgb(65, 65, 65);
        border-right-color: rgb(65, 65, 65);
        border-bottom-color: rgb(65, 65, 65);
        border-left-color: rgb(65, 65, 65);
      }

      .jss696 .deal-item,
      .jss696 .deal-stat-item {
        color: rgb(242, 242, 242);
        border-bottom-color: rgb(20, 21, 22);
      }

      .jss696 .deal-item .time1,
      .jss696 .deal-stat-item .time1 {
        color: rgb(163, 163, 163);
      }

      .jss696 .deal-item .stat-bar,
      .jss696 .deal-stat-item .stat-bar {
        background-color: rgba(154, 160, 166, 0.2);
      }

      .jss696 .deal-item .stat-bar .bar.other,
      .jss696 .deal-stat-item .stat-bar .bar.other {
        background-color: rgb(154, 160, 166);
      }

      .jss697 {
        color: var(--base0B);
      }

      .jss698 {
        color: var(--base08);
      }

      .jss699 {
        color: rgb(242, 242, 242);
      }

      .jss700 {
        background-color: rgb(13, 183, 135);
      }

      .jss701 {
        background-color: rgb(220, 31, 78);
      }

      .jss702 {
        background-color: rgba(13, 183, 135, 0.3);
      }

      .jss703 {
        background-color: rgba(220, 31, 78, 0.3);
      }

      .jss704 {
        color: rgb(163, 163, 163);
      }

      .jss706 > span {
        color: var(--base0F);
      }

      .jss706 > i {
        color: var(--base0F);
      }

      .jss710::after {
        border-top-color: var(--base01);
        border-right-color: var(--base01);
        border-bottom-color: var(--base01);
        border-left-color: var(--base01);
      }

      .jss335 > i {
        color: var(--base0F);
      }

      .jss335 > i:hover {
        color: var(--base0F);
      }

      .jss336 {
        color: rgb(125, 125, 125);
      }

      .jss762:hover {
        background-color: rgb(18, 34, 43);
      }

      .jss762.drag-active-top::before {
        background-color: var(--base0F);
      }

      .jss762.drag-active-bottom::before {
        background-color: var(--base0F);
      }

      .jss763 {
        background-color: rgb(17, 47, 66);
      }

      .jss763:hover {
        background-color: rgb(17, 47, 66);
      }

      .jss765 {
        background-color: rgba(0, 0, 0, 0);
      }

      .jss766 {
        background-color: rgba(0, 0, 0, 0);
      }

      .jss768 {
        color: rgb(242, 242, 242);
      }

      .jss770 {
        color: rgb(163, 163, 163);
      }

      .jss771 {
        color: rgb(242, 242, 242);
        background-color: rgb(245, 166, 35);
      }

      .jss772 {
        color: rgb(242, 242, 242);
      }

      .jss776 {
        color: rgb(163, 163, 163);
      }

      .jss777 {
        color: rgb(242, 242, 242);
      }

      .jss778 {
        color: rgb(163, 163, 163);
      }

      .jss779 {
        color: rgb(242, 242, 242);
      }

      .jss787 {
        color: var(--base0B);
      }

      .jss788 {
        color: var(--base08);
      }

      .jss327::after {
        border-top-color: var(--base01);
        border-right-color: var(--base01);
        border-bottom-color: var(--base01);
        border-left-color: var(--base01);
      }

      .jss328 {
        color: rgb(163, 163, 163);
      }

      .jss334 {
        color: rgb(163, 163, 163);
        border-top-color: var(--base02);
      }

      .jss311 {
        color: rgb(163, 163, 163);
        border-top-color: var(--base01);
      }

      .jss312 {
        background-color: rgb(65, 65, 65);
      }

      .jss312:hover {
        background-color: var(--base02);
      }

      .jss1079 {
        color: rgb(242, 242, 242);
      }

      .jss1079 .title {
        color: rgb(163, 163, 163);
      }

      .jss1079 .set-number {
        border-top-color: var(--base00);
        border-right-color: var(--base00);
        border-bottom-color: var(--base00);
        border-left-color: var(--base00);
        background-color: rgba(255, 255, 255, 0.1);
      }

      .jss1079 .set-number:hover {
        border-top-color: rgb(102, 108, 112);
        border-right-color: rgb(102, 108, 112);
        border-bottom-color: rgb(102, 108, 112);
        border-left-color: rgb(102, 108, 112);
      }

      .jss1079 .title .radio {
        color: rgb(242, 242, 242);
      }

      .jss1079 .title .nbboRadio {
        color: rgb(242, 242, 242);
      }

      .jss1079 .title .quoteEx {
        color: rgb(242, 242, 242);
      }

      .jss1080 {
        color: rgb(242, 242, 242);
      }

      .jss1082 .left {
        background-color: rgba(13, 183, 135, 0.15);
      }

      .jss1082 .right {
        background-color: rgba(220, 31, 78, 0.15);
      }

      .jss1082 .right .seq {
        background-color: rgba(220, 31, 78, 0.5);
      }

      .jss1082 .left .seq {
        background-color: rgba(13, 183, 135, 0.5);
      }

      .jss1082 div .volume {
        color: rgb(163, 163, 163);
        background-color: rgba(0, 0, 0, 0);
      }

      .jss1082 div .price {
        color: rgb(242, 242, 242);
        background-color: rgba(0, 0, 0, 0);
      }

      .jss1082 div .seq {
        color: rgb(255, 255, 255);
        background-color: rgba(255, 255, 255, 0.1);
      }

      .jss1082 div .seq::after {
        border-top-color: rgba(255, 255, 255, 0.5);
        border-right-color: rgba(255, 255, 255, 0.5);
        border-bottom-color: rgba(255, 255, 255, 0.5);
        border-left-color: rgba(255, 255, 255, 0.5);
      }

      .jss1083 {
        background-color: rgb(13, 183, 135);
      }

      .jss1084 {
        background-color: rgb(220, 31, 78);
      }

      .jss1085 {
        color: var(--base0B);
      }

      .jss1086 {
        color: var(--base08);
      }

      .jss1087 {
        color: rgb(242, 242, 242);
      }

      .jss1089 .quote-address {
        color: rgb(163, 163, 163);
        border-top-color: var(--base01);
      }

      .jss1089 .price-line > div .action {
        color: rgb(163, 163, 163);
        background-color: rgba(0, 0, 0, 0);
      }

      .jss1089 .price-line > div .price {
        color: rgb(242, 242, 242);
        background-color: rgba(0, 0, 0, 0);
      }

      .jss730 {
        color: rgb(138, 141, 145);
      }

      .jss731 > span {
        color: var(--base0F);
      }

      .jss731 > i {
        color: var(--base0F);
      }

      .jss421 {
        background-color: rgba(0, 0, 0, 0);
      }

      .jss421 .cont-nodata-tips {
        color: rgb(123, 130, 136);
      }

      .jss422 {
        color: rgb(242, 242, 242);
        background-color: var(--base01);
      }

      .jss422::after {
        border-top-color: rgb(65, 65, 65);
        border-right-color: rgb(65, 65, 65);
        border-bottom-color: rgb(65, 65, 65);
        border-left-color: rgb(65, 65, 65);
      }

      .jss423::after {
        border-top-color: var(--base00);
        border-right-color: var(--base00);
        border-bottom-color: var(--base00);
        border-left-color: var(--base00);
      }

      .jss423:hover {
        background-color: rgb(18, 34, 43);
      }

      .jss423:active {
        background-color: rgb(17, 47, 66);
      }

      .jss425 {
        color: rgb(242, 242, 242);
      }

      .jss427 {
        color: rgb(163, 163, 163);
      }

      .jss428::after {
        border-top-color: var(--base01);
        border-right-color: var(--base01);
        border-bottom-color: var(--base01);
        border-left-color: var(--base01);
      }

      .jss434::after {
        border-top-color: var(--base00);
        border-right-color: var(--base00);
        border-bottom-color: var(--base00);
        border-left-color: var(--base00);
      }

      .jss597::after {
        border-top-color: rgb(65, 65, 65);
        border-right-color: rgb(65, 65, 65);
        border-bottom-color: rgb(65, 65, 65);
        border-left-color: rgb(65, 65, 65);
      }

      .jss598 {
        color: rgb(163, 163, 163);
      }

      .jss601::after {
        border-top-color: var(--base01);
        border-right-color: var(--base01);
        border-bottom-color: var(--base01);
        border-left-color: var(--base01);
      }

      .jss581 {
        color: rgb(163, 163, 163);
      }

      .jss581:hover {
        color: rgb(242, 242, 242);
      }

      .jss583 {
        color: rgb(255, 207, 0);
      }

      .jss583:hover {
        color: rgb(255, 207, 0);
      }

      .jss573 {
        color: rgb(242, 242, 242);
      }

      .jss573 .tit-name {
        color: rgb(163, 163, 163);
      }

      .jss532 {
        background-color: var(--base01);
      }

      .jss533 {
        background-color: rgb(20, 21, 22);
      }

      .jss550 {
        color: rgb(242, 242, 242);
      }

      .jss552 {
        color: rgb(242, 242, 242);
        background-color: var(--base01);
      }

      .jss552::before {
        border-top-color: rgba(73, 73, 73, 0.4);
        border-right-color: rgba(73, 73, 73, 0.4);
        border-bottom-color: rgba(73, 73, 73, 0.4);
        border-left-color: rgba(73, 73, 73, 0.4);
        background-color: rgb(15, 15, 15);
      }

      .jss552::after {
        background-color: rgb(15, 15, 15);
      }

      .jss555 {
        color: rgb(125, 125, 125);
      }

      .jss557 {
        color: var(--base0B);
      }

      .jss558 {
        color: var(--base08);
      }

      .jss559 {
        color: rgb(242, 242, 242);
      }

      .jss560 {
        background-color: var(--base01);
      }

      .jss561 {
        color: rgb(255, 255, 255);
      }

      .jss562 {
        background-color: rgba(20, 20, 20, 0.3);
      }

      .jss563 {
        color: rgb(255, 255, 255);
      }

      .jss564 {
        color: rgba(255, 255, 255, 0.7);
      }

      .jss566 {
        color: rgb(255, 159, 9);
      }

      .jss569 {
        background-color: var(--base01);
      }

      .jss572 {
        color: rgb(242, 242, 242);
      }

      .jss617 {
        color: rgb(242, 242, 242);
        background-color: rgb(20, 21, 22);
        border-top-color: var(--base01);
      }

      .jss619 .cont-external-tips {
        color: rgb(242, 242, 242);
      }

      .jss622 {
        color: var(--base0F);
      }

      .jss622:hover {
        color: var(--base0F);
      }

      .jss623 {
        color: rgb(255, 159, 9);
      }

      .jss623:hover {
        color: rgb(255, 159, 9);
      }

      .jss624 {
        color: rgb(79, 79, 79);
      }

      .jss624:hover {
        color: rgb(242, 242, 242);
      }

      .jss664 tr td {
        background-color: rgb(20, 21, 22);
      }

      .jss654 {
        color: rgb(255, 255, 255);
        background-color: var(--base0F);
      }

      .jss654::after {
        border-top-color: var(--base0F);
        border-left-color: var(--base0F);
      }

      .jss655 {
        color: rgba(255, 255, 255, 0.8);
      }

      .jss655:hover {
        color: rgb(255, 255, 255);
      }

      .jss1097 {
        color: rgb(242, 242, 242);
      }

      .jss1097 .title {
        color: rgb(163, 163, 163);
      }

      .jss1097 .set-number {
        border-top-color: var(--base00);
        border-right-color: var(--base00);
        border-bottom-color: var(--base00);
        border-left-color: var(--base00);
        background-color: rgba(255, 255, 255, 0.1);
      }

      .jss1097 .set-number:hover {
        border-top-color: rgb(102, 108, 112);
        border-right-color: rgb(102, 108, 112);
        border-bottom-color: rgb(102, 108, 112);
        border-left-color: rgb(102, 108, 112);
      }

      .jss1097 .title .radio {
        color: rgb(242, 242, 242);
      }

      .jss1097 .title .nbboRadio {
        color: rgb(242, 242, 242);
      }

      .jss1097 .title .quoteEx {
        color: rgb(242, 242, 242);
      }

      .jss1098 {
        color: rgb(242, 242, 242);
      }

      .jss1100 .left {
        background-color: rgba(13, 183, 135, 0.15);
      }

      .jss1100 .right {
        background-color: rgba(220, 31, 78, 0.15);
      }

      .jss1100 .right .seq {
        background-color: rgba(220, 31, 78, 0.5);
      }

      .jss1100 .left .seq {
        background-color: rgba(13, 183, 135, 0.5);
      }

      .jss1100 div .volume {
        color: rgb(163, 163, 163);
        background-color: rgba(0, 0, 0, 0);
      }

      .jss1100 div .price {
        color: rgb(242, 242, 242);
        background-color: rgba(0, 0, 0, 0);
      }

      .jss1100 div .seq {
        color: rgb(255, 255, 255);
        background-color: rgba(255, 255, 255, 0.1);
      }

      .jss1100 div .seq::after {
        border-top-color: rgba(255, 255, 255, 0.5);
        border-right-color: rgba(255, 255, 255, 0.5);
        border-bottom-color: rgba(255, 255, 255, 0.5);
        border-left-color: rgba(255, 255, 255, 0.5);
      }

      .jss1101 {
        background-color: rgb(13, 183, 135);
      }

      .jss1102 {
        background-color: rgb(220, 31, 78);
      }

      .jss1103 {
        color: var(--base0B);
      }

      .jss1104 {
        color: var(--base08);
      }

      .jss1105 {
        color: rgb(242, 242, 242);
      }

      .jss1107 .quote-address {
        color: rgb(163, 163, 163);
        border-top-color: var(--base01);
      }

      .jss1107 .price-line > div .action {
        color: rgb(163, 163, 163);
        background-color: rgba(0, 0, 0, 0);
      }

      .jss1107 .price-line > div .price {
        color: rgb(242, 242, 242);
        background-color: rgba(0, 0, 0, 0);
      }

      .jss742 {
        color: rgb(138, 141, 145);
      }

      .jss743 > span {
        color: var(--base0F);
      }

      .jss743 > i {
        color: var(--base0F);
      }

      .jss462 {
        background-color: var(--base01);
      }

      .jss465 {
        color: rgb(242, 242, 242);
      }

      .jss466 {
        color: var(--base0B);
      }

      .jss467 {
        color: var(--base08);
      }

      .jss468 {
        color: rgb(242, 242, 242);
      }

      .jss469 {
        color: rgb(163, 163, 163);
      }

      .jss470 {
        color: rgb(255, 207, 0);
      }

      .jss640 {
        background-color: var(--base01);
      }

      .jss642 .tr .td:first-child {
        color: rgb(163, 163, 163);
      }

      .jss642 .tr .td:last-child {
        color: rgb(242, 242, 242);
      }

      .jss643 {
        color: rgb(163, 163, 163);
      }

      .jss643:hover {
        color: rgb(242, 242, 242);
      }

      .jss644 {
        color: var(--base0B) !important;
      }

      .jss645 {
        color: var(--base08);
      }

      .jss649 {
        color: var(--base0F);
      }

      .jss626 {
        color: rgb(238, 238, 238);
      }

      .jss626::after {
        border-top-color: rgb(65, 65, 65);
        border-right-color: rgb(65, 65, 65);
        border-bottom-color: rgb(65, 65, 65);
        border-left-color: rgb(65, 65, 65);
      }

      .jss677 {
        color: rgb(238, 238, 238);
      }

      .jss677::after {
        border-top-color: rgb(48, 48, 48);
        border-right-color: rgb(48, 48, 48);
        border-bottom-color: rgb(48, 48, 48);
        border-left-color: rgb(48, 48, 48);
      }

      .jss453 {
        background-color: var(--base01);
        border-bottom-color: rgb(47, 49, 53);
      }

      .jss458 {
        background-color: var(--base01);
      }

      .jss458.drag-active-top::before {
        background-color: rgb(7, 206, 236);
      }

      .jss458.drag-active-bottom::before {
        background-color: rgb(7, 206, 236);
      }

      .jss459 {
        color: rgb(242, 242, 242);
        background-color: var(--base01);
      }

      .jss459::after {
        border-top-color: rgb(65, 65, 65);
        border-right-color: rgb(65, 65, 65);
        border-bottom-color: rgb(65, 65, 65);
        border-left-color: rgb(65, 65, 65);
      }

      .jss460 {
        background-color: var(--base01);
      }

      .jss441 {
        background-color: var(--base00);
      }

      .jss444 {
        background-color: var(--base01);
      }

      .jss444::after {
        border-top-color: rgb(47, 49, 53);
        border-right-color: rgb(47, 49, 53);
        border-bottom-color: rgb(47, 49, 53);
        border-left-color: rgb(47, 49, 53);
      }

      .jss446 {
        color: rgb(163, 163, 163);
      }

      .jss446:hover {
        background-color: rgb(18, 34, 43);
      }

      .jss447 {
        color: rgb(242, 242, 242);
        background-color: rgb(17, 47, 66);
      }

      .jss353 {
        border-top-color: var(--base02);
        border-right-color: var(--base02);
        border-bottom-color: var(--base02);
        border-left-color: var(--base02);
        background-color: var(--base01);
      }

      .jss353:hover {
        border-top-color: var(--base0F);
        border-right-color: var(--base0F);
        border-bottom-color: var(--base0F);
        border-left-color: var(--base0F);
        background-color: var(--base0F);
      }

      .jss353:hover svg {
        color: rgb(255, 255, 255);
      }

      .jss354 {
      }

      .jss355 {
      }

      .jss356 {
      }

      .jss356.left {
        border-left-color: var(--base02);
      }

      .jss357 {
      }

      .jss358 {
        color: rgb(163, 163, 163);
      }

      .jss358:hover svg {
        color: rgb(255, 255, 255);
      }

      .jss414 {
        color: rgb(163, 163, 163);
      }

      .jss407 {
        color: rgb(163, 163, 163);
        background-color: var(--base01);
      }

      .jss410 {
        color: var(--base0F);
      }

      .jss410::before {
        background-color: var(--base0F);
      }

      .jss412 {
        color: var(--base0F);
        border-top-color: var(--base0F);
        border-right-color: var(--base0F);
        border-bottom-color: var(--base0F);
        border-left-color: var(--base0F);
        background-color: rgba(4, 157, 250, 0.2);
      }

      .jss366 {
        color: rgba(138, 141, 145, 0.5);
      }

      .jss269 {
        background-color: var(--base00);
      }

      .jss270 {
        background-color: var(--base01);
      }

      .jss273 {
        background-color: var(--base01);
      }

      .jss274 {
      }

      .jss275 {
      }

      .jss277 {
        background-color: var(--base01);
      }

      .jss278 {
      }

      .jss279 {
        background-color: var(--base01);
      }

      .jss282::after {
      }

      .jss292:hover {
        background-color: rgb(18, 34, 43);
      }

      .jss293 {
        color: rgb(242, 242, 242);
        background-color: var(--base01);
      }

      .jss294:hover {
        background-color: rgb(18, 34, 43);
      }

      .jss297::after {
        border-top-color: var(--base01);
        border-right-color: var(--base01);
        border-bottom-color: var(--base01);
        border-left-color: var(--base01);
      }

      .jss300 {
        background-color: rgb(65, 65, 65);
      }

      .jss300:hover {
        background-color: var(--base02);
      }

    }
  '';
}
