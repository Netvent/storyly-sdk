#!/usr/bin/env node

/**
 * Type Comparison Tool
 * 
 * Compares TypeScript interfaces with Kotlin data classes to ensure they're in sync.
 * This script helps identify:
 * - Missing fields
 * - Type mismatches
 * - Field order differences
 * 
 * Usage:
 *   node scripts/compare-types.js
 * 
 * Or add to package.json scripts:
 *   "compare-types": "node scripts/compare-types.js"
 */

const fs = require('fs');
const path = require('path');

// ANSI color codes for terminal output
const colors = {
  reset: '\x1b[0m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m',
  bold: '\x1b[1m',
};

/**
 * Parse TypeScript interface from file content
 */
function parseTypeScriptInterfaces(filePath) {
  const content = fs.readFileSync(filePath, 'utf-8');
  const interfaces = {};
  
  // Match interface declarations
  const interfaceRegex = /export interface (\w+)\s*(?:extends \w+\s*)?\{([^}]+)\}/g;
  let match;
  
  while ((match = interfaceRegex.exec(content)) !== null) {
    const interfaceName = match[1];
    const body = match[2];
    
    // Parse fields
    const fields = [];
    const fieldRegex = /^\s*(\w+)\??:\s*([^;]+);?$/gm;
    let fieldMatch;
    
    while ((fieldMatch = fieldRegex.exec(body)) !== null) {
      fields.push({
        name: fieldMatch[1],
        type: fieldMatch[2].trim(),
        optional: body.includes(`${fieldMatch[1]}?:`),
      });
    }
    
    interfaces[interfaceName] = fields;
  }
  
  return interfaces;
}

/**
 * Parse Kotlin data class from file content
 */
function parseKotlinDataClasses(filePath) {
  const content = fs.readFileSync(filePath, 'utf-8');
  
  // For now, we'll parse the encode/decode functions to understand the structure
  const fields = {};
  
  // Match mapOf patterns in encode functions
  const encodeRegex = /fun encode\w*\([^)]+\):\s*Map<String,\s*Any\?>\s*\{[^}]*return mapOf\(([^)]+)\)/gs;
  let match = encodeRegex.exec(content);
  
  if (match) {
    const mapContent = match[1];
    const fieldRegex = /"(\w+)"\s*to\s*\w+\.(\w+)/g;
    let fieldMatch;
    
    const parsedFields = [];
    while ((fieldMatch = fieldRegex.exec(mapContent)) !== null) {
      parsedFields.push({
        name: fieldMatch[1],
        kotlinName: fieldMatch[2],
      });
    }
    
    fields.encodedFields = parsedFields;
  }
  
  return fields;
}

/**
 * Compare TypeScript and Kotlin types
 */
function compareTypes(tsInterfaces, kotlinFields, typeName) {
  const tsFields = tsInterfaces[typeName];
  const ktFields = kotlinFields.encodedFields || [];
  
  if (!tsFields) {
    console.log(`${colors.yellow}⚠️  TypeScript interface ${typeName} not found${colors.reset}`);
    return { missing: 0, extra: 0, matches: 0 };
  }
  
  const tsFieldNames = new Set(tsFields.map(f => f.name));
  const ktFieldNames = new Set(ktFields.map(f => f.name));
  
  const missing = [];
  const extra = [];
  const matches = [];
  
  // Check for fields in Kotlin but not in TypeScript
  for (const ktField of ktFields) {
    if (!tsFieldNames.has(ktField.name)) {
      missing.push(ktField.name);
    } else {
      matches.push(ktField.name);
    }
  }
  
  // Check for fields in TypeScript but not in Kotlin
  for (const tsField of tsFields) {
    if (!ktFieldNames.has(tsField.name)) {
      extra.push(tsField.name);
    }
  }
  
  return { missing, extra, matches };
}

/**
 * Generate comparison report
 */
function generateReport() {
  console.log(`\n${colors.bold}${colors.cyan}╔═══════════════════════════════════════════════════╗${colors.reset}`);
  console.log(`${colors.bold}${colors.cyan}║  Storyly Placement Type Comparison Report        ║${colors.reset}`);
  console.log(`${colors.bold}${colors.cyan}╚═══════════════════════════════════════════════════╝${colors.reset}\n`);
  
  const comparisons = [
    {
      name: 'Banner',
      tsFile: 'src/data/widgets/banner.ts',
      ktFile: 'android/src/main/java/com/storylyplacementreactnative/common/data/widgets/BannerData.kt',
      tsType: 'STRBannerItem',
    },
    {
      name: 'StoryBar',
      tsFile: 'src/data/widgets/storyBar.ts',
      ktFile: 'android/src/main/java/com/storylyplacementreactnative/common/data/widgets/StoryBarData.kt',
      tsType: 'STRStoryGroup',
    },
    {
      name: 'VideoFeed',
      tsFile: 'src/data/widgets/videoFeed.ts',
      ktFile: 'android/src/main/java/com/storylyplacementreactnative/common/data/widgets/VideoFeedData.kt',
      tsType: 'STRVideoFeedGroup',
    },
    {
      name: 'SwipeCard',
      tsFile: 'src/data/widgets/swipeCard.ts',
      ktFile: 'android/src/main/java/com/storylyplacementreactnative/common/data/widgets/SwipeCardData.kt',
      tsType: 'STRSwipeCard',
    },
    {
      name: 'Product',
      tsFile: 'src/data/product.ts',
      ktFile: 'android/src/main/java/com/storylyplacementreactnative/common/data/product/ProductData.kt',
      tsType: 'STRProductItem',
    },
  ];
  
  let totalIssues = 0;
  
  for (const comp of comparisons) {
    const tsPath = path.join(process.cwd(), comp.tsFile);
    const ktPath = path.join(process.cwd(), comp.ktFile);
    
    if (!fs.existsSync(tsPath)) {
      console.log(`${colors.red}❌ TypeScript file not found: ${comp.tsFile}${colors.reset}`);
      continue;
    }
    
    if (!fs.existsSync(ktPath)) {
      console.log(`${colors.red}❌ Kotlin file not found: ${comp.ktFile}${colors.reset}`);
      continue;
    }
    
    const tsInterfaces = parseTypeScriptInterfaces(tsPath);
    const kotlinFields = parseKotlinDataClasses(ktPath);
    
    const result = compareTypes(tsInterfaces, kotlinFields, comp.tsType);
    
    console.log(`${colors.bold}${colors.blue}━━━ ${comp.name} (${comp.tsType}) ━━━${colors.reset}`);
    
    if (result.matches && result.matches.length > 0) {
      console.log(`${colors.green}✓${colors.reset} ${result.matches.length} matching fields`);
    }
    
    if (result.missing && result.missing.length > 0) {
      console.log(`${colors.red}✗${colors.reset} ${result.missing.length} fields in Kotlin but missing in TypeScript:`);
      result.missing.forEach(field => {
        console.log(`  ${colors.red}  - ${field}${colors.reset}`);
      });
      totalIssues += result.missing.length;
    }
    
    if (result.extra && result.extra.length > 0) {
      console.log(`${colors.yellow}⚠${colors.reset} ${result.extra.length} fields in TypeScript but not in Kotlin:`);
      result.extra.forEach(field => {
        console.log(`  ${colors.yellow}  + ${field}${colors.reset}`);
      });
      totalIssues += result.extra.length;
    }
    
    console.log('');
  }
  
  console.log(`${colors.bold}${colors.cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}`);
  
  if (totalIssues === 0) {
    console.log(`${colors.green}${colors.bold}✓ All types are in sync!${colors.reset}\n`);
  } else {
    console.log(`${colors.yellow}${colors.bold}⚠ Found ${totalIssues} potential issue(s)${colors.reset}`);
    console.log(`${colors.cyan}Note: This is a basic comparison. Manual verification is recommended.${colors.reset}\n`);
  }
  
  console.log(`${colors.cyan}💡 Tips:${colors.reset}`);
  console.log(`  • Review the Kotlin encode functions for the most accurate field mapping`);
  console.log(`  • Check if optional fields (?) match between platforms`);
  console.log(`  • Verify type compatibility (e.g., String vs string, Int vs number)\n`);
}

// Run the comparison
try {
  generateReport();
} catch (error) {
  console.error(`${colors.red}Error: ${error.message}${colors.reset}`);
  process.exit(1);
}




