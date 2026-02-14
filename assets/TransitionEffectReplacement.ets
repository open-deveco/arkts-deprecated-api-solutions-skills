
@Entry
@Component
struct TransitionEffectError {
  @State isExpanded: boolean = false;

  toggleState() {
    this.isExpanded = !this.isExpanded;
  }

  build() {
    Column() {
      Button('Toggle')
        .onClick(() => this.toggleState())

      if (this.isExpanded) {
        Text('Expanded Content')
      } else {
        Text('Collapsed Content')
      }
    }
    .transition(TransitionEffect.OPACITY.animation({ duration: 300 }))
  }
}
