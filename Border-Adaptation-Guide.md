# Write-InfoBox Border Adaptation Guide

## How the Border Adapts to Content Length

The `Write-InfoBox` function in OrionDesign features sophisticated **automatic border adaptation** that ensures content always fits perfectly within properly sized borders.

### 🎯 Core Adaptation Mechanisms

#### 1. **Automatic Width Calculation**
- Analyzes all content to determine optimal width
- Considers title length, key lengths, and value lengths
- Calculates minimum width needed for proper formatting
- Respects global width constraints while prioritizing content fit

#### 2. **Dynamic Border Rendering**
- **Top border**: Adjusts to `Width - Title.Length - 5` for decorative elements
- **Content lines**: Each line calculates padding to maintain perfect alignment  
- **Bottom border**: Matches calculated width exactly

#### 3. **Intelligent Constraints**
- **Minimum width**: 40 characters or title length + 6 (whichever is larger)
- **Content-based width**: Key length + value length + formatting space
- **Global maximum**: Respects `Set-OrionMaxWidth` setting (default: 100 chars)
- **Reasonable limits**: Prevents excessively wide or narrow boxes

### 🛠️ Width Control Options

#### **Automatic (Default)**
```powershell
# Border adapts to content automatically
Write-InfoBox -Title "Auto" -Content @{"Server"="PROD-01"; "Status"="Running"}
```

#### **Explicit Width Override**
```powershell
# Force specific width
Write-InfoBox -Title "Fixed" -Content @{"Key"="Value"} -Width 80
```

#### **Global Width Management**
```powershell
# Set global maximum for all functions
Set-OrionMaxWidth -Width 120
Write-InfoBox -Title "Global" -Content @{"Respects"="Global setting"}

# Reset to default
Set-OrionMaxWidth -Reset
```

#### **Content Wrapping (Enhanced)**
```powershell
# Enable word wrapping for long content
Write-InfoBox -Title "Wrapped" -Content @{
    "Long Description" = "This very long content will wrap across multiple lines"
} -Width 50 -WrapContent
```

### 🎨 Style-Specific Adaptations

All four visual styles adapt their borders differently while maintaining the same core logic:

#### **Classic Style**
- Box borders with `┌─┐ │ └─┘` characters
- Top border includes title with decorative spacing
- Content padding maintains perfect box alignment

#### **Modern Style** 
- Left border bar with `▌` character
- Horizontal rule under title adapts to width
- Bullet points maintain consistent indentation

#### **Simple Style**
- Underline title with dashes matching title length
- No side borders, relies on indentation
- Minimalist approach with adaptive underlines

#### **Accent Style**
- Full-width title bar with background color
- Title bar expands to calculated width
- Content uses accent bullets with consistent spacing

### 📏 Width Calculation Algorithm

The function uses this prioritized approach:

1. **Content Analysis**: Measure longest key + value combinations
2. **Title Requirements**: Ensure title fits with decorative elements  
3. **Minimum Enforcement**: Apply 40-character minimum for readability
4. **Global Constraints**: Respect `$script:OrionMaxWidth` setting
5. **Content Priority**: Expand beyond global limit if content requires it (up to 150 chars)
6. **Safety Bounds**: Prevent negative values or excessive widths

### ✨ Advanced Features

#### **Content-Aware Expansion**
- Automatically detects when content exceeds global limits
- Expands intelligently to accommodate necessary content
- Provides verbose feedback when expansion occurs

#### **Perfect Alignment**
- Every line calculates its own padding requirements
- Maintains consistent right border regardless of content variation
- Handles mixed key-value and simple string content seamlessly

#### **Word Wrapping Support**
- New `-WrapContent` parameter for enhanced readability
- Breaks long values across multiple lines while maintaining formatting
- Preserves box structure and alignment with wrapped content

### 🎯 Best Practices

1. **Let it adapt**: The automatic calculation works best in most cases
2. **Use global settings**: Configure `Set-OrionMaxWidth` for consistent output
3. **Override sparingly**: Use `-Width` only when specific requirements exist
4. **Enable wrapping**: Use `-WrapContent` for very long descriptive content
5. **Choose appropriate styles**: Different styles work better for different content types

### 🔧 Troubleshooting

**Problem**: Border too narrow for content
**Solution**: Content automatically expands border or use explicit `-Width`

**Problem**: Border too wide 
**Solution**: Set `Set-OrionMaxWidth` to constrain global maximum

**Problem**: Content gets cut off
**Solution**: Use `-WrapContent` parameter for long text

**Problem**: Inconsistent widths across multiple boxes
**Solution**: Set global width with `Set-OrionMaxWidth` or use explicit `-Width`