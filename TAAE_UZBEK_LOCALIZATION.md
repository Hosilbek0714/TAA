# TAAE Monitoring Platform (TAAE Uzbek Localization & Rebranding Project)

## Project Overview

This project is a comprehensive effort to fully localize and rebrand the TAAE monitoring platform into the **TAAE** (Tizimshunoslik va Analitik Asboblar / System Analytics and Tools) monitoring platform with complete Uzbek language support. The original TAAE is an enterprise-class, open-source distributed monitoring solution designed to monitor the performance and availability of network devices, servers, services, and other IT resources.

### Purpose
- **Complete Uzbek Translation**: Translate all user interface elements, messages, and documentation into Uzbek
- **Full Rebranding**: Transform TAAE into TAAE with custom branding, logos, and icons
- **Cultural Adaptation**: Ensure the translation and branding is culturally appropriate for Uzbek-speaking users
- **Custom Identity**: Create a unique monitoring platform identity for the Uzbek market
- **Accessibility**: Make monitoring accessible to Uzbek-speaking IT professionals and organizations
- **Brand Recognition**: Establish TAAE as a recognized monitoring solution in Uzbekistan

## Project Structure

```
taae-monitoring/ (formerly zabbix/)
├── assets/                      # TAAE Brand Assets
│   ├── favicon.ico              # TAAE favicon
│   ├── logo.svg                 # TAAE main logo
│   ├── icons/                   # TAAE custom icons
│   └── branding/                # Additional brand assets
├── ui/                          # Web interface files
│   ├── assets/                  # UI assets and images
│   │   ├── img/                 # Custom TAAE images
│   │   └── styles/              # TAAE brand styling
│   ├── locale/                  # Localization files
│   │   ├── uz/                  # Uzbek locale (Latin script)
│   │   ├── uz_UZ/               # Uzbek locale (Cyrillic script)
│   │   ├── add_new_language.sh  # Script to add new languages
│   │   ├── make_mo.sh           # Script to compile .po to .mo files
│   │   └── update_po.sh         # Script to update translation files
│   └── include/
│       ├── locales.inc.php      # Language configuration file
│       └── defines.inc.php      # Brand name definitions
├── branding/                    # TAAE Branding Resources
│   ├── logos/                   # TAAE logos in various formats
│   ├── icons/                   # TAAE icon sets
│   ├── colors.md                # TAAE color palette
│   └── style-guide.md           # TAAE style guidelines
├── docker-compose.yml           # Docker composition for development
├── Dockerfile                   # Docker build configuration (with branding)
└── src/                         # Source code directories
```

## Features

### TAAE Core Features
- **Resource Discovery**: Network entities, server resources, device monitoring
- **Metric Acquisition**: Agent and agent-less monitoring from multiple sources
- **Root Cause Analysis**: Real-time problem detection and correlation
- **Alerts & Notifications**: Multi-channel notification system
- **Visualization**: Graphs, lists, geomaps, and network topology
- **Multitenancy**: Support for multiple organizations and data centers
- **Flexibility**: Extensive customization and integration capabilities

### TAAE Platform Features
- ✅ **UI Language Support**: Uzbek language is registered in the system
- 📝 **Translation Files**: `.po` and `.mo` files for Uzbek translations
- 🎨 **Custom Branding**: Complete TAAE visual identity with logos and icons
- 🏷️ **Name Replacement**: All "TAAE" references replaced with "TAAE"
- 🔧 **Build Integration**: Docker setup includes Uzbek locale and branding assets
- 🌐 **Cultural Adaptation**: Proper date, time, and number formatting
- 📚 **Documentation**: Comprehensive setup and build documentation
- 🖼️ **Asset Management**: Automated copying of brand assets during Docker build
- 🎯 **Brand Consistency**: Unified TAAE identity across all platform components

## Prerequisites

### System Requirements
- **Docker**: Version 20.0+ with Docker Compose
- **Git**: For version control
- **Text Editor**: For translation work (recommended: Poedit, VS Code)

### Optional Tools
- **gettext**: For working with .po/.mo files manually
- **msgfmt**: For compiling translation files
- **Poedit**: GUI tool for translation management

## Quick Start

### 1. Clone the Repository
```bash
git clone <repository-url>
cd taae-monitoring
```

### 2. Build and Run with Docker
```bash
# Start the complete TAAE stack
docker-compose up -d --build

# Check container status
docker-compose ps

# View logs
docker-compose logs -f taae-web
```

### 3. Access the Application
- **Web Interface**: http://localhost:8098
- **Default Credentials**: Admin/taae (changed from zabbix)
- **Language Setting**: Go to User Settings → Language → Select "Uzbek (uz_UZ)"
- **Branding**: All logos and icons will display TAAE branding

## Docker Configuration

### Services Overview

#### PostgreSQL Database
```yaml
postgres:
  image: postgres:15
  environment:
    POSTGRES_USER: zabbix
    POSTGRES_PASSWORD: zabbix_password
    POSTGRES_DB: zabbix
```

#### TAAE Server (TAAE Server Backend)
```yaml
taae-server:
  image: zabbix/zabbix-server-pgsql:alpine-7.0-latest
  environment:
    DB_SERVER_HOST: postgres
    POSTGRES_USER: taae_user
    POSTGRES_PASSWORD: taae_password
    POSTGRES_DB: taae_monitoring
```

#### TAAE Web Interface (Custom Build with Branding)
```yaml
taae-web:
  image: taae-web:custom
  build:
    context: .
    dockerfile: Dockerfile.taae
  volumes:
    # Localization files
    - ./ui/locale/uz_UZ:/usr/share/zabbix/locale/uz_UZ:ro
    - ./ui/locale/uz:/usr/share/zabbix/locale/uz:ro
    - ./ui/include/locales.inc.php:/usr/share/zabbix/include/locales.inc.php:ro
    # TAAE Branding assets
    - ./assets/logo.svg:/usr/share/zabbix/assets/img/logo.svg:ro
    - ./assets/favicon.ico:/usr/share/zabbix/favicon.ico:ro
    - ./branding/icons:/usr/share/zabbix/assets/img/icons:ro
    - ./branding/logos:/usr/share/zabbix/assets/img/logos:ro
    # Custom TAAE configurations
    - ./ui/include/defines.inc.php:/usr/share/zabbix/include/defines.inc.php:ro
    - ./ui/assets/styles:/usr/share/zabbix/assets/styles:ro
```

### Volume Mappings
The Docker setup mounts essential files for complete TAAE transformation:
- **Localization**: Uzbek locale directories (`uz` and `uz_UZ`)
- **Language Config**: Language configuration file (`locales.inc.php`)
- **Translation Files**: Compiled `.mo` files for runtime
- **Brand Assets**: TAAE logos, icons, and visual elements
- **Custom Styles**: TAAE-specific CSS and styling
- **Brand Definitions**: Name replacement configurations
- **Frontend Assets**: All UI customizations for TAAE identity

## TAAE Transformation & Localization Workflow

### Current Status
- ✅ Language code registered: `uz_UZ` in `locales.inc.php`
- ✅ Locale directories created: `ui/locale/uz/` and `ui/locale/uz_UZ/`
- ✅ Docker configuration updated with branding support
- 🎨 Brand asset directories structured
- 🏷️ Name replacement system prepared
- 📝 Translation files: Ready for population
- 🖼️ Icon and logo replacement framework established

### Brand Transformation Process

#### 1. Asset Preparation
```bash
# Create TAAE brand asset directories
mkdir -p branding/{logos,icons,styles}
mkdir -p assets/{icons,branding}

# Prepare TAAE assets in various formats
branding/logos/
├── taae-logo-main.svg        # Main TAAE logo
├── taae-logo-small.png       # Small size logo
├── taae-logo-large.png       # Large size logo
├── taae-logo-white.svg       # White version for dark backgrounds
└── taae-logo-favicon.ico     # Favicon

branding/icons/
├── taae-icon-16x16.png      # Small icons
├── taae-icon-32x32.png      # Medium icons
├── taae-icon-64x64.png      # Large icons
└── taae-iconset.svg         # Icon sprite sheet
```

#### 2. Name Replacement Configuration
Create `ui/include/defines.inc.php` for global name replacements:
```php
<?php
// TAAE Brand Name Definitions
define('PRODUCT_NAME', 'TAAE');
define('PRODUCT_FULL_NAME', 'Tizimshunoslik va Analitik Asboblar');
define('PRODUCT_DESCRIPTION', 'Monitoring va Analitik Platform');
define('COPYRIGHT_MESSAGE', '© 2024 TAAE Monitoring Platform');
define('DEFAULT_THEME', 'taae-theme');
```

#### 3. Docker Build Integration
Create `Dockerfile.taae` for complete asset copying with explicit source mappings:
```dockerfile
FROM zabbix/zabbix-web-nginx-pgsql:alpine-7.0-latest

# ===== TAAE BRANDING ASSETS MAPPING =====
# Main Logo Replacements
COPY assets/logo.svg /usr/share/zabbix/assets/img/logo.svg
COPY branding/logos/taae-logo-main.svg /usr/share/zabbix/assets/img/
COPY branding/logos/taae-logo-small.png /usr/share/zabbix/assets/img/
COPY branding/logos/taae-logo-large.png /usr/share/zabbix/assets/img/

# Favicon and Browser Icons
COPY assets/favicon.ico /usr/share/zabbix/favicon.ico
COPY branding/logos/taae-logo-favicon.ico /usr/share/zabbix/assets/img/favicon.ico

# Navigation and UI Icons
COPY branding/icons/taae-icon-16x16.png /usr/share/zabbix/assets/img/icon-16.png
COPY branding/icons/taae-icon-32x32.png /usr/share/zabbix/assets/img/icon-32.png
COPY branding/icons/taae-icon-64x64.png /usr/share/zabbix/assets/img/icon-64.png

# Header and Footer Logos
COPY branding/logos/taae-logo-header.svg /usr/share/zabbix/assets/img/zabbix_logo.svg
COPY branding/logos/taae-logo-white.svg /usr/share/zabbix/assets/img/zabbix_logo_sidebar.svg

# Dashboard and Login Page Assets
COPY branding/logos/taae-logo-login.png /usr/share/zabbix/assets/img/zabbix_logo_login.png
COPY branding/logos/taae-logo-dashboard.svg /usr/share/zabbix/assets/img/dashboard_logo.svg

# Copy all icons to respective UI directories
COPY branding/icons/* /usr/share/zabbix/assets/img/icons/
COPY branding/logos/* /usr/share/zabbix/assets/img/logos/

# Custom TAAE Styles and Themes
COPY branding/styles/taae-theme.css /usr/share/zabbix/assets/styles/
COPY branding/styles/* /usr/share/zabbix/assets/styles/

# Copy localization files
COPY ui/locale/uz_UZ /usr/share/zabbix/locale/uz_UZ
COPY ui/locale/uz /usr/share/zabbix/locale/uz
COPY ui/include/locales.inc.php /usr/share/zabbix/include/
COPY ui/include/defines.inc.php /usr/share/zabbix/include/

# Copy custom UI modifications
COPY ui/assets/styles /usr/share/zabbix/assets/styles
COPY ui/assets/img /usr/share/zabbix/assets/img

# ===== CRITICAL: REPLACE ORIGINAL ZABBIX ASSETS =====
# Override original TAAE branding files with TAAE equivalents
RUN cp /usr/share/zabbix/assets/img/taae-logo-main.svg /usr/share/zabbix/assets/img/zabbix_logo.svg
RUN cp /usr/share/zabbix/assets/img/taae-logo-header.svg /usr/share/zabbix/assets/img/zabbix_logo_header.svg
RUN cp /usr/share/zabbix/assets/img/taae-icon-32x32.png /usr/share/zabbix/assets/img/zabbix_icon.png

# Set proper permissions
RUN chown -R nginx:nginx /usr/share/zabbix/assets/
RUN chown -R nginx:nginx /usr/share/zabbix/locale/

# Update index.php and other files to use TAAE branding
RUN find /usr/share/zabbix -name "*.php" -exec sed -i 's/TAAE/TAAE/g' {} \;
RUN find /usr/share/zabbix -name "*.js" -exec sed -i 's/TAAE/TAAE/g' {} \;
RUN find /usr/share/zabbix -name "*.css" -exec sed -i 's/zabbix_logo/taae-logo/g' {} \;
```

### Translation Process

#### 1. Generate Translation Template
```bash
cd ui/locale
./update_po.sh
```

#### 2. Create Uzbek Translation Files
```bash
# For uz_UZ locale
./add_new_language.sh uz_UZ

# For uz locale (if needed)
./add_new_language.sh uz
```

#### 3. Translate Strings
Edit the generated `.po` files in `ui/locale/uz_UZ/LC_MESSAGES/frontend.po`:
```po
#: example.php:123
msgid "Dashboard"
msgstr "Boshqaruv paneli"

#: example.php:124
msgid "Monitoring"
msgstr "Monitoring"
```

#### 4. Brand Name Translation
Update translation files to include TAAE branding:
```po
#: branding
msgid "TAAE"
msgstr "TAAE"

#: branding
msgid "TAAE monitoring"
msgstr "TAAE monitoring"

#: branding
msgid "System Analytics and Tools"
msgstr "Tizimshunoslik va Analitik Asboblar"
```

#### 5. Compile Translations
```bash
# Compile all .po files to .mo files
./make_mo.sh
```

#### 6. Build TAAE Docker Image
```bash
# Build custom TAAE image with all assets
docker build -f Dockerfile.taae -t taae-web:custom .

# Verify asset copying
docker run --rm taae-web:custom ls -la /usr/share/zabbix/assets/img/logos/
```

#### 7. Test Complete TAAE Platform
```bash
# Rebuild and restart containers with TAAE branding
docker-compose down
docker-compose up -d --build

# Verify TAAE branding is applied
curl -s http://localhost:8098 | grep -i "TAAE"
```

### Translation Guidelines

#### Language Standards
- **Script**: Use Latin script for uz_UZ locale
- **Terminology**: Maintain consistency with IT terminology
- **Context**: Consider technical context in translations
- **Pluralization**: Set correct plural forms in .po file headers

#### Example Translations
| English/TAAE | Uzbek/TAAE | Context |
|---------|-------|---------|
| Dashboard | Boshqaruv paneli | Main interface |
| Host | Xost | IT infrastructure |
| Trigger | Trigger | Monitoring alerts |
| Template | Shablon | Configuration |
| Network | Tarmoq | Infrastructure |
| TAAE | TAAE | Brand name |
| TAAE Server | TAAE Server | System component |
| TAAE Agent | TAAE Agent | Monitoring agent |
| Monitoring | Monitoring | Core function |
| System Analytics | Tizim tahlili | Platform purpose |

## Building from Source

### Manual Build Process
```bash
# Install dependencies
sudo apt-get update
sudo apt-get install -y build-essential autoconf automake

# Configure build
./bootstrap.sh
./configure --enable-server --enable-agent --with-postgresql

# Build
make

# Install
sudo make install
```

### Docker Build Process
```bash
# Build custom TAAE web image with all branding
docker build -f Dockerfile.taae -t taae-web:custom .

# Or use docker-compose with TAAE configuration
docker-compose build taae-web

# Build with cache busting for fresh assets
docker build --no-cache -f Dockerfile.taae -t taae-web:latest .

# Verify TAAE assets are copied correctly
docker run --rm taae-web:custom find /usr/share/zabbix -name "*taae*" -o -name "*TAAE*"
```

### Frontend Asset Management
```bash
# Automated script to prepare all TAAE assets
#!/bin/bash
# prepare_taae_assets.sh

echo "Preparing TAAE brand assets..."

# Create asset directories
mkdir -p {branding/{logos,icons,styles},assets/{icons,branding},ui/assets/{img,styles}}

# Copy TAAE logos to multiple locations
cp branding/logos/taae-logo-main.svg assets/logo.svg
cp branding/logos/taae-logo-favicon.ico assets/favicon.ico

# Copy icons for UI
cp -r branding/icons/* ui/assets/img/icons/

# Copy custom TAAE styles
cp -r branding/styles/* ui/assets/styles/

echo "TAAE assets prepared for Docker build"
```

## Frontend Asset Source Mapping & Build Process

### Original TAAE Asset Locations (What Gets Replaced)
During the Docker build, TAAE assets replace these original TAAE locations:

#### **Primary Logo Locations:**
```bash
# Original TAAE Assets → TAAE Replacements
/usr/share/zabbix/assets/img/zabbix_logo.svg → taae-logo-header.svg
/usr/share/zabbix/assets/img/zabbix_logo_header.svg → taae-logo-header.svg
/usr/share/zabbix/assets/img/zabbix_logo_sidebar.svg → taae-logo-white.svg
/usr/share/zabbix/assets/img/zabbix_logo_login.png → taae-logo-login.png
/usr/share/zabbix/favicon.ico → taae-logo-favicon.ico
```

#### **Icon and UI Element Locations:**
```bash
# Icons used throughout the interface
/usr/share/zabbix/assets/img/icon-16.png → taae-icon-16x16.png
/usr/share/zabbix/assets/img/icon-32.png → taae-icon-32x32.png
/usr/share/zabbix/assets/img/icon-64.png → taae-icon-64x64.png
/usr/share/zabbix/assets/img/zabbix_icon.png → taae-icon-32x32.png

# Dashboard and widget icons
/usr/share/zabbix/assets/img/dashboard_logo.svg → taae-logo-dashboard.svg
/usr/share/zabbix/ui/assets/img/ → (entire TAAE icon set)
```

#### **CSS and Style References:**
```bash
# CSS files that reference logos
/usr/share/zabbix/assets/styles/blue-theme.css
/usr/share/zabbix/assets/styles/dark-theme.css
/usr/share/zabbix/assets/styles/hc-light.css
/usr/share/zabbix/assets/styles/hc-dark.css
```

### TAAE Asset Source Structure (Build Input)
Your local project should have this structure for successful Docker builds:

```bash
taae-monitoring/
├── branding/                    # 📁 Source TAAE Brand Assets
│   ├── logos/
│   │   ├── taae-logo-main.svg           # Main TAAE logo
│   │   ├── taae-logo-header.svg         # Header logo (replaces zabbix_logo.svg)
│   │   ├── taae-logo-sidebar.svg        # Sidebar logo
│   │   ├── taae-logo-white.svg          # White version for dark themes
│   │   ├── taae-logo-login.png          # Login page logo
│   │   ├── taae-logo-dashboard.svg      # Dashboard widget logo
│   │   ├── taae-logo-small.png          # Small size (16x16, 24x24)
│   │   ├── taae-logo-large.png          # Large size (64x64, 128x128)
│   │   └── taae-logo-favicon.ico        # Browser favicon
│   ├── icons/
│   │   ├── taae-icon-16x16.png          # Small UI icons
│   │   ├── taae-icon-32x32.png          # Medium UI icons
│   │   ├── taae-icon-64x64.png          # Large UI icons
│   │   ├── taae-iconset.svg             # Icon sprite sheet
│   │   └── ui-elements/                # Individual UI element icons
│   │       ├── menu-icon.svg
│   │       ├── settings-icon.svg
│   │       └── notification-icon.svg
│   └── styles/
│       ├── taae-theme.css               # Custom TAAE theme
│       ├── taae-colors.css              # TAAE color definitions
│       └── logo-overrides.css          # Logo positioning rules
└── assets/                      # 📁 Quick Access Assets
    ├── logo.svg                        # Symlink to taae-logo-main.svg
    ├── favicon.ico                     # Symlink to taae-logo-favicon.ico
    └── branding/                       # Additional brand materials
```

### Build-Time Asset Processing

#### **Step 1: Pre-Build Asset Validation**
```bash
#!/bin/bash
# validate_taae_assets.sh

echo "🔍 Validating TAAE assets before Docker build..."

# Check required logo files
required_logos=(
    "branding/logos/taae-logo-main.svg"
    "branding/logos/taae-logo-header.svg"
    "branding/logos/taae-logo-white.svg"
    "branding/logos/taae-logo-login.png"
    "branding/logos/taae-logo-favicon.ico"
)

for logo in "${required_logos[@]}"; do
    if [[ ! -f "$logo" ]]; then
        echo "❌ Missing required asset: $logo"
        exit 1
    else
        echo "✅ Found: $logo"
    fi
done

# Check icon files
required_icons=(
    "branding/icons/taae-icon-16x16.png"
    "branding/icons/taae-icon-32x32.png"
    "branding/icons/taae-icon-64x64.png"
)

for icon in "${required_icons[@]}"; do
    if [[ ! -f "$icon" ]]; then
        echo "❌ Missing required icon: $icon"
        exit 1
    else
        echo "✅ Found: $icon"
    fi
done

echo "✅ All TAAE assets validated successfully!"
```

#### **Step 2: Asset Optimization During Build**
```dockerfile
# In Dockerfile.taae - Add optimization steps
FROM zabbix/zabbix-web-nginx-pgsql:alpine-7.0-latest

# Install image optimization tools
RUN apk add --no-cache imagemagick optipng

# Copy and optimize TAAE assets
COPY branding/logos/ /tmp/logos/
COPY branding/icons/ /tmp/icons/

# Optimize PNG files
RUN find /tmp/icons -name "*.png" -exec optipng -o7 {} \;

# Generate missing icon sizes if needed
RUN convert /tmp/logos/taae-logo-main.svg -resize 16x16 /tmp/icons/taae-icon-16x16.png
RUN convert /tmp/logos/taae-logo-main.svg -resize 32x32 /tmp/icons/taae-icon-32x32.png
RUN convert /tmp/logos/taae-logo-main.svg -resize 64x64 /tmp/icons/taae-icon-64x64.png

# Now copy optimized assets to final locations
# [Previous COPY commands with /tmp/ sources]
```

#### **Step 3: Runtime Asset Verification**
```bash
#!/bin/bash
# verify_taae_deployment.sh

echo "🔍 Verifying TAAE branding in deployed container..."

CONTAINER_NAME="taae-web"

# Check if TAAE logos are properly placed
echo "Checking logo deployment..."
docker exec $CONTAINER_NAME ls -la /usr/share/zabbix/assets/img/ | grep -i taae

# Verify original TAAE assets are replaced
echo "Verifying TAAE asset replacement..."
docker exec $CONTAINER_NAME file /usr/share/zabbix/assets/img/zabbix_logo.svg

# Check favicon
echo "Checking favicon..."
docker exec $CONTAINER_NAME ls -la /usr/share/zabbix/favicon.ico

# Test web accessibility
echo "Testing web interface..."
curl -s http://localhost:8098 | grep -i "TAAE" && echo "✅ TAAE branding detected in HTML"

echo "🎯 TAAE deployment verification complete!"
```

### Frontend Build Integration Points

#### **PHP Template Integration**
The frontend builds need to reference TAAE assets in these key files:
```php
// ui/include/page_header.php
$logo_src = 'assets/img/taae-logo-header.svg';

// ui/include/views/general.login.php  
$login_logo = 'assets/img/taae-logo-login.png';

// ui/include/classes/core/CView.php
$favicon = 'favicon.ico'; // Points to TAAE favicon
```

#### **JavaScript Asset References**
```javascript
// ui/js/main.js - Update logo references
const LOGO_PATH = 'assets/img/taae-logo-main.svg';
const ICON_PATH = 'assets/img/icons/';

// ui/js/dashboard.js - Dashboard logo
const DASHBOARD_LOGO = 'assets/img/taae-logo-dashboard.svg';
```

#### **CSS Asset Integration**
```css
/* ui/assets/styles/taae-theme.css */
.header-logo {
    background-image: url('../img/taae-logo-header.svg');
}

.login-logo {
    background-image: url('../img/taae-logo-login.png');
}

.sidebar-logo {
    background-image: url('../img/taae-logo-white.svg');
}
```

### Asset Caching and Performance

#### **Browser Caching Headers**
```nginx
# In nginx.conf (part of Docker image)
location ~* \.(svg|png|ico|css|js)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
    add_header Vary Accept-Encoding;
}

# Specific cache busting for TAAE assets
location /assets/img/taae- {
    expires 30d;
    add_header Cache-Control "public";
}
```

#### **Asset Versioning Strategy**
```bash
# Generate version hash for cache busting
TAAE_VERSION=$(date +%Y%m%d_%H%M%S)
echo "TAAE_ASSET_VERSION='$TAAE_VERSION'" > ui/include/taae_version.php

# Update asset URLs with version
sed -i "s/taae-logo-main.svg/taae-logo-main.svg?v=$TAAE_VERSION/g" ui/**/*.php
```

This comprehensive mapping ensures that all TAAE branding assets are properly integrated during the Docker build process, replacing all original TAAE visual elements with TAAE branding.

## Development Setup

### Local Development Environment
```bash
# Start only database and server
docker-compose up -d postgres taae-server

# Run web interface locally for development with TAAE branding
cd ui
php -S localhost:8080

# Or run with TAAE assets mounted
docker-compose up -d postgres taae-server
docker run -p 8080:8080 -v $(pwd)/ui:/usr/share/zabbix -v $(pwd)/branding:/usr/share/zabbix/assets/branding taae-web:custom
```

### File Watching and Hot Reload
```bash
# Watch for changes in locale files and branding assets
find ui/locale -name "*.po" -o -path "branding/*" -o -path "assets/*" | entr -r docker-compose restart taae-web

# Watch specifically for TAAE asset changes
find branding assets ui/assets -type f | entr -r sh -c 'docker-compose build taae-web && docker-compose up -d taae-web'

# Auto-compile translations and rebuild on changes
find ui/locale -name "*.po" | entr -r sh -c 'cd ui/locale && ./make_mo.sh && docker-compose restart taae-web'
```

### TAAE Development Workflow
```bash
# Complete development setup script
#!/bin/bash
# dev_setup_taae.sh

echo "Setting up TAAE development environment..."

# Prepare assets
./prepare_taae_assets.sh

# Start development stack
docker-compose up -d postgres taae-server

# Build and start TAAE web with development mounts
docker-compose up -d taae-web

echo "TAAE development environment ready at http://localhost:8098"
echo "Username: Admin, Password: taae"
```

## Testing

### Functional Testing
1. **Language Switching**: Test UI language switching functionality
2. **Text Display**: Verify all translated text displays correctly
3. **Character Encoding**: Ensure UTF-8 support for Uzbek characters
4. **Date/Time Formatting**: Check localized date and time formats

### Translation Validation
```bash
# Check .po file syntax
msgfmt --check-format ui/locale/uz_UZ/LC_MESSAGES/frontend.po

# Check for missing translations
grep -c "msgstr \"\"" ui/locale/uz_UZ/LC_MESSAGES/frontend.po
```

## Deployment

### Production Deployment
```bash
# Build production images
docker-compose -f docker-compose.prod.yml build

# Deploy with proper security
docker-compose -f docker-compose.prod.yml up -d
```

### Configuration for Production
- Set secure database passwords
- Configure SSL/TLS certificates
- Set up proper backup procedures
- Configure monitoring and logging

## Contributing

### How to Contribute
1. **Fork** the repository
2. **Create** a feature branch for your translations
3. **Follow** the translation guidelines
4. **Test** your changes thoroughly
5. **Submit** a pull request with detailed description

### Translation Review Process
1. Initial translation by contributor
2. Technical review for accuracy
3. Cultural review by native speaker
4. Testing in development environment
5. Final approval and merge

## Troubleshooting

### Common Issues

#### Docker Issues
```bash
# Container not starting
docker-compose logs zabbix-web

# Permission issues
sudo chown -R $(id -u):$(id -g) ui/locale/

# Port conflicts
docker-compose down
sudo netstat -tulpn | grep :8098
```

#### Localization Issues
```bash
# Missing .mo files
cd ui/locale && ./make_mo.sh

# Character encoding issues
file ui/locale/uz_UZ/LC_MESSAGES/frontend.po
# Should show: UTF-8 Unicode text

# Language not appearing in UI
grep -n "uz_UZ" ui/include/locales.inc.php
```

### Debug Mode
Enable debug mode in TAAE configuration:
```php
// In zabbix.conf.php
$ZBX_CONFIG['debug'] = true;
```

## Performance Considerations

### Optimization Tips
- Use compiled `.mo` files instead of `.po` files in production
- Enable PHP opcache for better performance
- Configure proper database indexing
- Use CDN for static assets

### Monitoring Performance
- Monitor translation loading times
- Check memory usage with different locales
- Benchmark UI response times

## Security

### Security Best Practices
- Regular security updates
- Secure database configuration
- Input validation for translated content
- Regular security audits

### Locale Security
- Validate translation file integrity
- Prevent code injection in translations
- Secure file permissions for locale files

## License

This project maintains the same license as TAAE: **AGPL-3.0-only**

See [COPYING](COPYING) for full license text.

## Resources

### Documentation
- [TAAE Official Documentation](https://www.zabbix.com/documentation/current/en/)
- [TAAE Installation Manual](https://www.zabbix.com/documentation/current/en/manual/installation)
- [gettext Documentation](https://www.gnu.org/software/gettext/manual/)

### Community
- [TAAE Community Forums](https://www.zabbix.com/forum/)
- [TAAE GitHub Repository](https://github.com/zabbix/zabbix)
- Uzbek Localization Team: [Contact Information]

### Tools
- [Poedit](https://poedit.net/) - Translation editor
- [Weblate](https://weblate.org/) - Web-based translation platform
- [Crowdin](https://crowdin.com/) - Localization management platform

## Changelog

### Version History
- **v1.0.0**: Initial Uzbek localization setup
- **v1.1.0**: Docker integration completed
- **v1.2.0**: Translation workflow established
- **v2.0.0**: Full UI translation (target)

## Roadmap

### Short-term Goals (1-3 months)
- [ ] Complete core UI translations (90%+)
- [ ] Implement date/time localization
- [ ] Set up automated testing
- [ ] Create translation memory

### Medium-term Goals (3-6 months)
- [ ] Complete all UI translations (100%)
- [ ] Translate documentation
- [ ] Community feedback integration
- [ ] Performance optimization

### Long-term Goals (6+ months)
- [ ] Official TAAE inclusion
- [ ] Maintenance and updates
- [ ] Regional dialect support
- [ ] Mobile app localization

---

**Note**: This project is actively maintained. For questions, issues, or contributions, please contact the development team or create an issue in the project repository.