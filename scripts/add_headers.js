const fs = require('fs');
const path = require('path');

const srcDir = path.join(__dirname, '../navatation-web/src');
const dateStr = '2026-06-10';

function walkDir(dir) {
    let results = [];
    const list = fs.readdirSync(dir);
    list.forEach(file => {
        const filePath = path.join(dir, file);
        const stat = fs.statSync(filePath);
        if (stat && stat.isDirectory()) {
            results = results.concat(walkDir(filePath));
        } else {
            if (filePath.endsWith('.ts') || filePath.endsWith('.tsx')) {
                results.push(filePath);
            }
        }
    });
    return results;
}

const files = walkDir(srcDir);
let modifiedCount = 0;

files.forEach(file => {
    let content = fs.readFileSync(file, 'utf8');
    
    // Check if there is a block comment at the very beginning or close to it
    // Some files might have imports first, so we just check if "/**" exists in the first 500 characters
    const head = content.substring(0, 500);
    if (!head.includes('/**')) {
        const fileName = path.basename(file);
        let desc = '前端核心业务逻辑与组件';
        if (file.includes('components')) desc = `前端UI组件：${fileName}`;
        if (file.includes('hooks')) desc = `前端自定义钩子：${fileName}`;
        if (file.includes('services')) desc = `前端服务：${fileName}`;
        if (file.includes('stores')) desc = `前端状态管理：${fileName}`;
        
        const header = `/**
 * @description ${desc}
 * @date ${dateStr}
 */
`;
        fs.writeFileSync(file, header + content, 'utf8');
        modifiedCount++;
        console.log(`Added header to ${file}`);
    }
});

console.log(`Total modified: ${modifiedCount}`);
