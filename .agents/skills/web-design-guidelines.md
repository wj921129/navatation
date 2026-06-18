---
name: web-design-guidelines
description: Use when reviewing or building UI components. Audits accessibility (A11y), UX, interactions, and aesthetic details.
---

# Web UI & Design Guidelines

鍦ㄧ紪鍐欏墠绔?UI 浠ｇ爜鏃讹紝涓ユ牸閬靛畧浠ヤ笅鐢ㄦ埛浣撻獙涓庣晫闈氦浜掓渶浣冲疄璺碉紝纭繚搴旂敤鍏峰鈥滅幇浠ｃ€佺簿鑷淬€佸彲璁块棶鈥濈殑鐗硅川锛?

## 1. 鏃犻殰纰嶈闂?(Accessibility / A11y) - CRITICAL
- **璇箟鍖栨爣绛?*锛氳兘鐢?`<button>` 鐨勫湴鏂圭粷涓嶄娇鐢ㄥ甫鏈?`onClick` 鐨?`<div>`銆?
- **閿洏瀵艰埅**锛氭墍鏈変氦浜掑厓绱犲繀椤诲彲浠ラ€氳繃 `Tab` 閿幏鍙栫劍鐐广€傚浜庤嚜瀹氫箟浜や簰缁勪欢锛堝寮圭獥銆佷笅鎷夎彍鍗曪級锛岄渶瑕佹纭疄鐜?`Esc` 鍏抽棴閫昏緫鍜岀劍鐐归櫡闃憋紙Focus Trap锛夈€?
- **Aria 灞炴€?*锛氫粎鍑浘鏍囨棤娉曠悊瑙ｇ殑鎸夐挳锛堝 X 鍥炬爣鐨勫叧闂寜閽級锛屽繀椤诲姞涓?`aria-label="Close"` 鎴?`title="Close"`銆?

## 2. 鐒︾偣涓庣姸鎬佸彲瑙佹€?(Focus & State) - HIGH
- **涓嶈绉婚櫎鐒︾偣鐜?*锛氫弗绂佸叏灞€璁剧疆 `outline: none;`锛屽繀椤讳繚鐣欐垨鑷畾涔?`:focus-visible` 鏍峰紡锛岀‘淇濋敭鐩樼敤鎴风煡閬撳綋鍓嶅湪鍝€?
- **鎿嶄綔鍙嶉**锛氭墍鏈夋寜閽€佸崱鐗囥€侀摼鎺ュ繀椤绘湁娓呮櫚鐨?`:hover`銆乣:active`锛堟寜涓嬶級鍜?`:disabled`锛堢鐢級鐘舵€佹牱寮忋€傜姝㈢敤鎴峰湪绂佺敤鎸夐挳涓婃搷浣滄椂娌℃湁瑙嗚鎻愮ず銆?

## 3. 鍔ㄧ敾涓庝氦浜?(Animation & Interaction) - MEDIUM
- **寰姩鐢?(Micro-interactions)**锛氫娇鐢?CSS `transition` 涓?Hover 鐘舵€併€佸睍寮€/鎶樺彔銆佹ā鎬佹寮瑰嚭绛夋彁渚?150ms-300ms 鐨勫钩婊戣繃娓°€?
- **鎬ц兘鍙嬪ソ鐨勫姩鐢?*锛氬敖閲忓彧瀵?`transform` 鍜?`opacity` 杩涜鍔ㄧ敾澶勭悊锛岄伩鍏嶅 `width`銆乣height` 鎴?`margin` 鍒朵綔鍔ㄧ敾锛堜互闃叉棰戠箒瑙﹀彂 Layout 鍥炴祦锛夈€?
- **闃叉姈涓庤妭娴?*锛氭秹鍙婃粴鍔ㄧ洃鍚紙Scroll锛夈€佺獥鍙ｇ缉鏀撅紙Resize锛夋垨鎼滅储妗嗚繛缁緭鍏ョ殑鍦烘櫙锛屽繀椤诲己鍒跺寘瑁归槻鎶栵紙Debounce锛夋垨鑺傛祦锛圱hrottle锛夊嚱鏁般€?

## 4. 琛ㄥ崟涓庢帓鐗?(Forms & Typography) - MEDIUM
- **鍘熺敓楠岃瘉涓庨敊璇彁绀?*锛氳緭鍏ユ鍙戠敓閿欒鏃讹紝杈规搴斿彉绾紝骞舵彁渚涙槑纭殑鏂囧瓧鎻愮ず锛堜笉浠呬粎鏄浘鏍囷級銆?
- **闃查噸澶嶆彁浜?*锛氳〃鍗曞湪鎻愪氦锛堣姹傚悗绔帴鍙ｏ級鏈熼棿锛屽繀椤诲皢鎸夐挳璁剧疆涓?Loading 鎴?Disabled 鐘舵€侊紝闃叉鐢ㄦ埛鐙傜偣瀵艰嚧鑴忔暟鎹€?
- **娣辫壊妯″紡鏀寔**锛氬湪瀹氫箟棰滆壊鏃讹紝浼樺厛鑰冭檻浣跨敤璁捐绯荤粺鐨?CSS Variables锛堝 `var(--bg-primary)`锛夋垨鑰?Tailwind 鐨勬殫榛戜慨楗扮锛堝 `dark:bg-slate-800`锛夛紝閬垮厤纭紪鐮佸鑷存殫榛戞ā寮忓け鏁堛€
