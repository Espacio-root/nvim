local lorem_text = [[Lorem ipsum odor amet, consectetuer adipiscing elit. Nostra semper conubia integer fusce at auctor imperdiet consequat. Ipsum consectetur pharetra urna torquent porta ex felis. Lacus nam mauris elementum euismod purus duis sociosqu neque. Turpis nisi platea nunc duis rhoncus dignissim scelerisque senectus. Et nulla eros dapibus molestie nunc; maecenas venenatis vitae. Aenean vel purus dui, ante praesent litora eleifend. Amagna lacus habitasse semper arcu pharetra! Urna faucibus nisl nunc felis eros per.

Viverra rutrum dis fames semper lacus; ligula vestibulum pharetra. Quis nec velit parturient sit lobortis! Venenatis velit sagittis quisque aenean nascetur odio. Feugiat himenaeos nisl finibus torquent viverra tempus euismod quam. Nostra primis nulla facilisi faucibus duis. Cubilia faucibus laoreet scelerisque nullam, convallis dictumst. Mollis senectus fusce a porta egestas mollis facilisis. Primis tempor amet dignissim ipsum leo sed lobortis luctus. Mauris erat tristique nulla varius dis sociosqu ad.

Cubilia dui in, vitae interdum curabitur ante dolor ullamcorper. Suspendisse consequat nam imperdiet tellus ultricies justo vitae. Cras dignissim suscipit class, pulvinar egestas eros. Rhoncus rutrum cubilia nisl ultricies himenaeos, aliquet ornare pellentesque conubia. Mi pretium turpis mus purus nec turpis ex interdum. Faucibus tincidunt euismod at curabitur mauris congue, dis iaculis ligula. Volutpat curabitur per ligula a molestie integer fermentum ac placerat.

Ultricies bibendum turpis nibh vivamus mus blandit. Rhoncus elit per gravida ante primis auctor sed. Gravida hendrerit iaculis et, penatibus posuere dui. Lacinia scelerisque posuere; tellus accumsan feugiat fermentum mi. Molestie platea vestibulum lectus congue tortor id. Imperdiet gravida dui vitae habitant fusce cursus primis pharetra. Faucibus nec justo vivamus non nam fames torquent. Praesent ut et natoque, a ultricies duis. Lorem ultricies et eleifend aliquam lacus vulputate.

Torquent magnis cubilia sem tincidunt; cras litora velit eget faucibus. Orci tempus pulvinar; mollis cras erat porta natoque turpis. Id luctus rutrum faucibus risus efficitur maecenas egestas tincidunt. Quam turpis curabitur nibh est nisi sem. Dis ligula nam elementum sapien diam. Amet at elit mollis convallis ligula venenatis habitant. Fames nec potenti hendrerit libero lacinia suspendisse. Condimentum suscipit ornare vivamus placerat leo nisl viverra.

Maecenas nec hac arcu, parturient odio penatibus tempor fringilla. Tortor dictumst phasellus arcu nulla; nisi amet varius conubia dapibus. Proin vitae enim finibus diam elementum lacinia tincidunt magnis. Fusce pellentesque viverra platea quisque dui magnis aliquet. Auctor pulvinar semper ad euismod fringilla. Viverra odio duis neque pellentesque felis ornare suscipit commodo. Quis erat phasellus nullam rhoncus augue, dapibus duis. Maecenas ultricies fermentum dui parturient maximus pellentesque. Hac rutrum facilisi per mauris; aliquet congue arcu.

Euismod urna varius vehicula parturient montes hac litora. Sit sagittis lobortis aptent risus mi lacinia. Pretium mattis mattis ut euismod egestas nascetur scelerisque convallis. Potenti in netus ut dis dolor rhoncus a penatibus. Integer aliquam magnis justo faucibus integer nunc efficitur turpis. Consequat malesuada curabitur elementum taciti placerat sodales.

Condimentum id molestie nullam in per nullam euismod gravida. Congue tortor sociosqu volutpat vel tellus. Imperdiet massa facilisis semper commodo nibh morbi fermentum finibus? Augue laoreet pulvinar ante diam; commodo potenti ligula malesuada aliquam. Curae leo eleifend elementum; maecenas et suspendisse lobortis iaculis. Nam orci velit sodales ex curabitur mattis fusce. Euismod viverra tempor phasellus vel pretium interdum urna finibus massa.

Curabitur parturient inceptos per efficitur vitae nibh. Erat vitae volutpat commodo feugiat magnis. Blandit finibus orci venenatis ante felis porttitor. Elementum facilisis porttitor quam luctus condimentum parturient. Curae sagittis accumsan tortor auctor maecenas aliquam. Sollicitudin potenti lacinia nunc augue a dictum feugiat egestas sit. Litora ullamcorper commodo taciti tortor consectetur sociosqu libero non. Montes varius ridiculus montes duis, mus sollicitudin at laoreet. Diam maximus est ridiculus enim class placerat.

Nibh magna fames leo, turpis feugiat volutpat. Erat dis cursus ut malesuada nec sagittis dapibus viverra. Duis turpis leo faucibus netus class metus sollicitudin? Sociosqu odio metus duis mollis suspendisse; consectetur sodales. Egestas suscipit quam porttitor elementum eleifend suscipit ultrices. Vehicula ex pellentesque vehicula sociosqu, scelerisque varius cursus litora. Pretium egestas pharetra imperdiet; vulputate tortor eu sollicitudin laoreet.]]


local lorem = s(
  {
    trig = "lorem(%d+) ",
    dsrc = "Inserts lorem ipsum text",
    regTrig = true,
    snippetType = "autosnippet",
  },
  f(function(_,snip)
    local words = vim.split(lorem_text, " ")
    local selected_words = {}
    for i = 1, math.min(snip.captures[1], #words) do
      table.insert(selected_words, words[i])
    end
    return table.concat(selected_words, " ")
  end)
)

return {
  lorem,
}
