import 't1_1_push_pop.dart' as t11;
import 't1_2_three_screens.dart' as t12;
import 't1_3_replace.dart' as t13;
import 't2_1_named_routes.dart' as t21;
import 't2_2_menu_routes.dart' as t22;
import 't2_3_not_found.dart' as t23;
import 't3_1_products.dart' as t31;
import 't3_2_greeting.dart' as t32;
import 't4_1_screen_arguments.dart' as t41;
import 't4_2_send_number.dart' as t42;
import 't5_1_fade.dart' as t51;
import 't5_2_slide_right.dart' as t52;
import 't5_3_sheet.dart' as t53;
import 't5_4_scale_fade.dart' as t54;
import 't6_1_go_router.dart' as t61;
import 't6_2_path_params.dart' as t62;
import 't6_3_extra.dart' as t63;
// add one import per new task

const selected = '6.3'; // change this, then press R

void main() {
  final tasks = <String, void Function()>{
    '1.1': t11.main,
    '1.2': t12.main,
    '1.3': t13.main,
    '2.1': t21.main,
    '2.2': t22.main,
    '2.3': t23.main,
    '3.1': t31.main,
    '3.2': t32.main,
    '4.1': t41.main,
    '4.2': t42.main,
    '5.1': t51.main,
    '5.2': t52.main,
    '5.3': t53.main,
    '5.4': t54.main,
    '6.1': t61.main,
    '6.2': t62.main,
    '6.3': t63.main,
  };
  tasks[selected]!();
}