---
name: react-best-practices
description: Use when creating or refactoring React components. Contains critical performance rules and hooks best practices.
---

# React Best Practices (Vite/Client-side SPA)

褰撶紪鍐欍€侀噸鏋勬垨瀹℃煡 React 浠ｇ爜鏃讹紝蹇呴』涓ユ牸閬靛畧浠ヤ笅浼樺寲瑙勫垯锛岄伩鍏嶆€ц兘鈥滄按妗舵晥搴斺€濓細

## 1. 娑堥櫎缃戠粶鐎戝竷娴?(Eliminate Waterfalls) - CRITICAL
- **涓嶈涓茶鎷夊彇鏁版嵁**锛氬鏋滀竴涓粍浠堕渶瑕佸姞杞藉涓浉浜掔嫭绔嬬殑鏁版嵁婧愶紝蹇呴』浣跨敤 `Promise.all()` 骞跺彂璇锋眰锛屼笉瑕佸啓鎴愯繛缁殑 `await`銆?
- **鐘舵€佹彁鍗囨垨棰勬媺鍙?*锛氬鏋滃瓙缁勪欢鐨勬暟鎹緷璧栫埗缁勪欢鐨勬暟鎹紝灏藉彲鑳藉湪鐖剁骇骞跺彂鎷夊彇鎵€鏈夋墍闇€鏁版嵁骞堕€氳繃 props 浼犻€掞紝閬垮厤瀛愮粍浠跺湪鐖剁粍浠舵覆鏌撳畬鎴愬悗鎵嶅紑濮嬭姹傘€?

## 2. 閲嶆柊娓叉煋浼樺寲 (Re-render Optimization) - HIGH
- **灞€閮ㄧ姸鎬佺鐞?*锛氬皢棰戠箒鍙樺寲鐨勭姸鎬侊紙濡傝緭鍏ユ鍐呭銆佹嫋鎷藉潗鏍囷級灏佽鍦ㄦ渶灏忕殑鍙嫭绔嬫覆鏌撳瓙缁勪欢涓紝闃叉寮曡捣鍏ㄥ眬鎴栧ぇ鑼冨洿鐨?Re-render銆?
- **鎱庣敤 useMemo/useCallback**锛氫笉瑕佺洸鐩粰鎵€鏈夊嚱鏁板姞 `useCallback`銆傚彧鏈夊綋鎶婂嚱鏁颁綔涓?Prop 浼犵粰缁忚繃 `React.memo` 鍖呰鐨勫瓙缁勪欢锛屾垨鑰呭嚱鏁版槸鏌愪釜 `useEffect` 鐨勪緷璧栭」鏃讹紝鎵嶉渶瑕佷娇鐢ㄥ畠浠€?
- **Key 鐨勬纭娇鐢?*锛氬垪琛ㄦ覆鏌撲腑缁濆绂佹浣跨敤 `index` 浣滀负 `key`锛堥櫎闈炲垪琛ㄦ案涓嶉噸鎺掑簭銆佹柊澧炴垨鍒犻櫎锛夛紝蹇呴』浣跨敤鍞竴 ID銆?

## 3. 缁勪欢璁捐涓庣姸鎬?(Component Architecture) - MEDIUM
- **鍗曚竴鑱岃矗**锛氬綋涓€涓粍浠惰秴杩?200 琛屼唬鐮佹垨鎵挎媴澶氱瑙嗚/閫昏緫鑱岃矗鏃讹紝蹇呴』鎷嗗垎銆?
- **琛嶇敓鐘舵€佽绠?*锛氫笉瑕佸湪 `useEffect` 涓牴鎹竴涓?state 鍘?`setState` 鍙︿竴涓?state銆備换浣曞彲浠ュ湪娓叉煋闃舵鐩存帴璁＄畻鍑烘潵鐨勫€硷紝閮藉簲璇ョ洿鎺ヨ绠楋紙蹇呰鏃剁敤 `useMemo` 鍖呰９锛夈€?

## 4. 渚濊禆浼樺寲 (Bundle Size) - HIGH
- 姘歌繙涓嶈鍏ㄩ噺寮曞叆鍥炬爣搴擄紙渚嬪 `import * as Icons`锛夛紝浠呮寜闇€瀵煎叆鎵€闇€鐨勫叿浣撴ā鍧椼€?
- 澶嶆潅杩愮畻搴擄紙濡傚簽澶х殑 Excel 瀵煎嚭銆丳DF 鐢熸垚妯″潡锛夊簲浣跨敤 React 鐨?`lazy` 鍜?`Suspense` 杩涜鍔ㄦ€佹寜闇€鍔犺浇銆
