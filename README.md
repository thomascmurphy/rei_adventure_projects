# rei_adventure_projects
Code Example for REI

I included a solely functional solution [rei_example.rb](../master/rei_example.rb) and an object-oriented version [rei_example_class.rb](../master/rei_example_class.rb) as it seemed to fit the nature of the task a little better, the only difference being that you'd run `controller = SlotsControl.new` first and then commands like `controller.size(5)`. I also included a simple happy-path set of tests to make sure I wasn't screwing up anything obvious. I was running everything in IRB (`$ irb`) but also Rails console would work fine (`$ rails c`).

## Methods

| Method       | Functional       | Object-oriented                   |
| ------------ |------------------| ----------------------------------|
| Init         | N/A              | `controller = SlotsController.new`|
| Size         | `size n`         | `controller.size n`               |
| Add          | `add slot`       | `controller.add slot`             |
| Remove       | `rm slot`        | `controller.rm slot`              |
| Move         | `mv slot1, slot2`| `controller.mv slot1, slot2`      |
| Undo         | `undo n`         | `controller.undo n`               |
| Replay       | `replay n`       | `controller.replay n`             |
| Run Tests    | `run_tests`      | `controller.run_tests`            |
