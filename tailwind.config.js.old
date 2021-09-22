module.exports = {
  important: false,
  // theme: {
  //   extend: {},
  // },
  theme: {
    customForms: theme => ({
      default: {
        input: {
          borderRadius: theme("borderRadius.md"),
          backgroundColor: theme("colors.gray.100"),
          borderColor: theme("colors.gray.500"),
          "&:focus": {
            backgroundColor: theme("colors.white"),
          }
        },
        select: {
          borderRadius: theme("borderRadius.lg"),
          boxShadow: theme("boxShadow.default"),
          borderColor: theme("colors.gray.500"),
        },
        checkbox: {
          // width: theme('spacing.6'),
          // height: theme('spacing.6'),
        },
      },
    })
  },
  variants: {},
  plugins: [
    require("@tailwindcss/custom-forms")
  ]
}
