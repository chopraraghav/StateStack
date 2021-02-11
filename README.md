# StateStack

Assumptions:

- The stack subview list is not changed during runtime.
- The traversal always starts on the first index.
- Each stack subview needs to setup its own expanded & collapsed view.
- Any UIView can be an expanded or collapsed view, but it should be able to calculate its content height on its own. 
- For the sample app, a mock expanded & collapsed view is reused for all 3 stack subviews, with the focus being on the stack layer implementation & abstraction.
- Each stack subview should ideally have its own config (e.g. MVP / VIPER) to handle its own internal states & any API calls. Additionally, these actions can be delegated to the View Controller, by extending the current delegate implementations.
- While the bottom-top (move forward) & top-bottom (move backward) animation are intrinsic to the stack view, each subview can use the overridable functions to animate expanded view on each expand action (likewise for collapsed view - collapse action).
- Each subview can listen to CTA action (by overriding ‘handleCTATap’) for internal state processing & then signal completion using ‘StateStackSubviewDelegate’. The delegate can also be used by the subview to update any CTA related config (state, title, color).
- Tapping on a collapsed subview moves the stack to that subview, causing it to expand.
