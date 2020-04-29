# Developpment mode

Please install this module from npm :

```npm i -g elm-live```

Need to run this command for using route

```elm-live src/Main.elm --open -- --output=elm.js```

# Build application
```$ elm make src/Main.elm --output elm.js```

# Serve application
```$ elm reactor```

Project launched on localhost:8000

# Help tutos
- Elm doc : https://guide.elm-lang.org/
- Create modal : https://medium.com/front-end-weekly/programming-in-elm-modals-in-a-pure-environment-bc2cf98fbc33
- Elm spa example : https://github.com/rtfeldman/elm-spa-example
- Create navigation between pages : https://elmprogramming.com/navigating-to-list-posts-page.html
- Import module in a page : https://discourse.elm-lang.org/t/a-simple-example-of-splitting-view-update-into-a-separate-module/3107
- Elm live npm package : https://www.npmjs.com/package/elm-live

# CSS Code Conventions

## CSS architecture
- Global class
- Icons

### Home page :

- Navbar
- Section categories
- Section images
- Footer

### Categories page :

Creating...

### Images page :

Creating...

## CSS Classname
For global class like "link", "icon" etc, there is no conventions but
find explicit name

### Icon name
- Write icon
- Find an icon name

Example for trash icon

```icon_trash```

### Section name
- Write page name
- Write section name
- Write section

Example for home page section "categories"

```home_categories_section```

### Container name
- Write page name
- Write section name
- Write what you want to contain

Example for thumbnails categories in home page

```home_categories_thumbnails```

## Comments
Copy and paste comments already written

### Comments name
For general comments like navbar icon etc there is no convention but use an explicit name

When Should I add comments ?
- When there is a new section
- When there is general class
- When if you think some selectors are difficult to read

Example for "categories" section in home page

```HOME SECTION CATEGORIES```
