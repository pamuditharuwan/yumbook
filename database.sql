-- ==============================================================================
-- YumBook Database Schema & Initial Data
-- ICT 1209: Web Technologies Mini-Project
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS `yumbook_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `yumbook_db`;

-- Drop tables if they exist to allow clean re-import
DROP TABLE IF EXISTS `ratings`;
DROP TABLE IF EXISTS `recipes`;
DROP TABLE IF EXISTS `contact_messages`;
DROP TABLE IF EXISTS `users`;

-- -----------------------------------------------------------------------------
-- Table: users
-- -----------------------------------------------------------------------------
CREATE TABLE `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(100) NOT NULL UNIQUE,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- Table: recipes
-- -----------------------------------------------------------------------------
CREATE TABLE `recipes` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NULL,
  `title` VARCHAR(200) NOT NULL,
  `category` ENUM('Breakfast', 'Lunch', 'Dinner', 'Dessert', 'Vegan', 'Beverages') NOT NULL,
  `origin` VARCHAR(100) NOT NULL DEFAULT 'Global',
  `cooking_time` INT NOT NULL COMMENT 'Cooking time in minutes',
  `ingredients` TEXT NOT NULL,
  `steps` TEXT NOT NULL,
  `instructions` TEXT NULL,
  `image_url` VARCHAR(500) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- Table: ratings
-- -----------------------------------------------------------------------------
CREATE TABLE `ratings` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `recipe_id` INT NOT NULL,
  `user_ip_or_id` VARCHAR(100) NOT NULL,
  `rating` TINYINT NOT NULL CHECK (`rating` BETWEEN 1 AND 5),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`recipe_id`) REFERENCES `recipes`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- Table: messages (Contact Queries)
-- -----------------------------------------------------------------------------
CREATE TABLE `messages` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `message` TEXT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Backward compatibility view for contact_messages
CREATE OR REPLACE VIEW `contact_messages` AS SELECT * FROM `messages`;

-- -----------------------------------------------------------------------------
-- Seed Sample Recipe Authors (Passwords securely hashed via BCrypt)
-- -----------------------------------------------------------------------------
INSERT INTO `users` (`id`, `username`, `name`, `email`, `password`) VALUES
(1, 'gordon_ramsay', 'Chef Gordon Ramsay', 'chefgordonramsay@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(2, 'alice_waters', 'Chef Alice Waters', 'chefalicewaters@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(3, 'dharshan_munidasa', 'Chef Dharshan Munidasa', 'chefdharshanmunidasa@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(4, 'sanjeev_kapoor', 'Chef Sanjeev Kapoor', 'chefsanjeevkapoor@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(5, 'wolfgang_puck', 'Chef Wolfgang Puck', 'chefwolfgangpuck@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(6, 'rick_bayless', 'Chef Rick Bayless', 'chefrickbayless@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(7, 'publis_silva', 'Chef Publis Silva', 'chefpublissilva@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(8, 'enrique_olvera', 'Chef Enrique Olvera', 'chefenriqueolvera@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(9, 'martin_yan', 'Chef Martin Yan', 'chefmartinyan@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(10, 'franco_pepe', 'Chef Franco Pepe', 'cheffrancopepe@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(11, 'massimo_bottura', 'Chef Massimo Bottura', 'chefmassimobottura@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(12, 'david_thompson', 'Chef David Thompson', 'chefdavidthompson@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(13, 'auguste_escoffier', 'Chef Auguste Escoffier', 'chefaugusteescoffier@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(14, 'peter_kuruvita', 'Chef Peter Kuruvita', 'chefpeterkuruvita@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(15, 'mario_batali', 'Chef Mario Batali', 'chefmariobatali@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(16, 'antonio_carluccio', 'Chef Antonio Carluccio', 'chefantoniocarluccio@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(17, 'thomas_keller', 'Chef Thomas Keller', 'chefthomaskeller@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(18, 'niranjala_senaratne', 'Chef Niranjala Senaratne', 'chefniranjalasenaratne@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(19, 'dominique_ansel', 'Chef Dominique Ansel', 'chefdominiqueansel@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(20, 'alain_ducasse', 'Chef Alain Ducasse', 'chefalainducasse@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(21, 'paul_bocuse', 'Chef Paul Bocuse', 'chefpaulbocuse@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(22, 'cedric_grolet', 'Chef Cédric Grolet', 'chefcdricgrolet@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(23, 'pierre_herme', 'Chef Pierre Hermé', 'chefpierreherm@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(24, 'masaharu_morimoto', 'Chef Masaharu Morimoto', 'chefmasaharumorimoto@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(25, 'jose_andres', 'Chef José Andrés', 'chefjosandrs@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(26, 'yotam_ottolenghi', 'Chef Yotam Ottolenghi', 'chefyotamottolenghi@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(27, 'roy_choi', 'Chef Roy Choi', 'chefroychoi@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(28, 'luke_nguyen', 'Chef Luke Nguyen', 'cheflukenguyen@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm'),
(29, 'henrique_sa_pessoa', 'Chef Henrique Sá Pessoa', 'chefhenriquespessoa@yumbook.lk', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm');


-- -----------------------------------------------------------------------------
-- Seed 100 Realistic Sample Recipes
-- -----------------------------------------------------------------------------

INSERT INTO `recipes` (`id`, `user_id`, `title`, `category`, `origin`, `cooking_time`, `ingredients`, `steps`, `image_url`) VALUES
(1, 17, 'Fluffy Blueberry Buttermilk Pancakes', 'Breakfast', 'United States (Maine / New England)', 25,
'2 cups all-purpose flour (sifted)
2.5 tsp aluminum-free baking powder
1/2 tsp baking soda
2 tbsp granulated sugar
1/2 tsp fine sea salt
1.75 cups cultured whole buttermilk (room temperature)
2 large farm-fresh eggs (separated)
4 tbsp unsalted European butter (melted and slightly cooled)
1 tsp pure Madagascar vanilla extract
1.5 cups fresh organic wild blueberries
Pure Grade-A amber maple syrup & salted butter for serving',
'Step 1: Mise en Place & Dry Sifting - In a large copper or glass mixing bowl, thoroughly sift together the unbleached all-purpose flour, baking powder, baking soda, granulated sugar, and fine sea salt. Sifting aerates the flour particles and guarantees that the chemical leavening agents are distributed with mathematical precision throughout the dry base.
Step 2: Emulsifying the Liquid Base - In a separate ceramic bowl, whisk together the cultured buttermilk, room-temperature egg yolks, melted cooled butter, and vanilla extract until completely homogenized and emulsified. Using room-temperature buttermilk prevents the melted butter from seizing into hard fat pellets.
Step 3: Whipping Egg Whites for Leavening - In a clean, grease-free stainless-steel bowl, whip the egg whites with a balloon whisk until soft, billowy peaks form. This classic French soufflé technique introduces microscopic air cells that expand dramatically when exposed to skillet heat, yielding an extraordinarily light, cloud-like crumb.
Step 4: Gentle Incorporation & Gluten Rest - Pour the buttermilk-yolk mixture into the dry flour base. Using a wide silicone spatula, fold the ingredients together in broad, gentle strokes just until the flour is hydrated. Crucial culinary rule: small flour lumps must remain; never overmix. Delicately fold in the whipped egg whites, followed by gently scattering in the fresh blueberries. Let the batter rest undisturbed at room temperature for 10 minutes to allow the wheat starches to swell and the gluten matrix to relax.
Step 5: Precision Griddle Conditioning - Preheat a seasoned heavy cast-iron griddle or thick-bottomed crêpe pan over medium-low heat until surface temperature reaches exactly 375°F (190°C). Lightly grease the cooking surface with clarified butter (ghee), wiping away excess with a folded paper towel to maintain a micro-film of fat.
Step 6: Griddle Cooking & Bubble Formation - Ladle 1/3 cup of batter per pancake onto the griddle, leaving 2 inches between rounds. Cook undisturbed for 2.5 to 3 minutes. Observe the surface: cook until small bubbles rise, burst, and form open craters that hold their shape while the perimeter of the pancake appears matte and set.
Step 7: The Master Flip & Steam Finish - Slide a thin offset metal spatula smoothly beneath the pancake in one decisive motion and flip. Cook the reverse side for 1.5 to 2 minutes until puffed, springy to a gentle finger touch, and rich golden brown.
Step 8: Artisanal Presentation - Transfer immediately to warm ceramic plates. Stack three high, crown with a generous medallion of salted French cultured butter, and drizzle liberally with warmed pure Grade-A amber maple syrup.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/6/67/Shakshouka_-_Coast_Cafe%2C_Worthing_2026-05-25.jpg/960px-Shakshouka_-_Coast_Cafe%2C_Worthing_2026-05-25.jpg'),

(2, 2, 'Artisanal Avocado Toast with Soft Poached Egg', 'Breakfast', 'Australia (Sydney Café Culture)', 15,
'2 thick-cut (1-inch) slices rustic country sourdough bread (naturally fermented)
2 ripe Hass avocados (slightly yielding to gentle thumb pressure)
1 tbsp freshly squeezed Meyer lemon juice
1 tbsp cold-pressed extra virgin olive oil (first harvest)
2 farm-fresh Grade A large eggs (chilled)
1 tbsp distilled white vinegar (for the poaching bath)
1/4 tsp crushed Aleppo red pepper flakes
1 tbsp toasted pepitas (pumpkin seeds) & black sesame seeds
Maldon flaky sea salt and freshly cracked tellicherry peppercorns',
'Step 1: Preparing the Poaching Vessel - Fill a deep 3-quart saucepan with 4 inches of filtered water. Bring to a gentle simmer over medium heat until the water registers between 185°F and 190°F (85°C to 88°C), characterized by small pinhead bubbles clinging to the bottom. Add 1 tablespoon distilled white vinegar; the mild acidity accelerates protein coagulation without imparting flavor.
Step 2: Egg Strainer Technique - Crack each chilled egg into a fine-mesh cocktail strainer over a small bowl. Gently swirl for 10 seconds to allow the thin, watery outer albumen to drain away, retaining only the firm, gelatinous inner white and vibrant intact yolk. Transfer each strained egg into its own small porcelain ramekin.
Step 3: Crushing the Avocado Base - Halve the Hass avocados, discard pits, and scoop the buttery flesh into a shallow wooden or ceramic bowl. Coarsely crush the flesh with the tines of a heavy dinner fork to preserve textural variation.
Step 4: Herb-Infused Avocado Seasoning - Fold into the crushed avocado fresh Meyer lemon juice, half the extra virgin olive oil, a pinch of Maldon sea salt, and cracked black pepper. Mix gently until emulsified while leaving distinct avocado chunks. Do not over-mash into baby food.
Step 5: Sourdough Griddling & Garlic Rub - Brush both faces of the artisanal sourdough slices with extra virgin olive oil. Toast on a heavy cast-iron ribbed grill pan over medium-high heat for 2 minutes per side until deeply scored with smoky char marks, crispy on the exterior, and chewy in the crumb. Lightly rub the warm crust with a halved raw garlic clove.
Step 6: Executing the Water Vortex Poach - Using the handle of a slotted spoon, stir the simmering water in rapid circular motions to create a gentle, steady whirlpool vortex in the center. Carefully drop one egg directly into the low-pressure eye of the vortex; the centrifugal current cleanly wraps the egg whites around the yolk into a teardrop shape. Poach undisturbed for exactly 3 minutes and 15 seconds for a warm, liquid golden yolk and tender white.
Step 7: Blotting & Temperature Equilibrium - Lift the poached egg from the water bath using a perforated slotted spoon. Delicately rest the base of the spoon on folded linen or paper towels for 10 seconds to wick away excess water that could soften the toast.
Step 8: Plating & Architectural Garnish - Mound the crushed seasoned avocado generously across the warm grilled sourdough. Gently nestle the warm poached egg into the center of the avocado bed. Drizzle with cold-pressed olive oil, scatter with Aleppo chili flakes, toasted pepitas, black sesame, and crunchy Maldon sea salt crystals. Serve immediately.',
'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=1000&q=80'),

(3, 7, 'Authentic Sri Lankan Pol Roti with Fresh Lunu Miris', 'Breakfast', 'Sri Lanka', 30,
'2.5 cups unbleached all-purpose wheat flour (attah or plain flour)
1.5 cups freshly scraped coconut (freshly grated pol, room temperature)
1 tsp fine sea salt
1 small red shallot or onion (finely minced)
2 green bird''s eye chilies (finely sliced into micro-rounds)
1 sprig fresh green curry leaves (finely chiffonaded)
Lukewarm water as needed (approx. 3/4 to 1 cup)
Virgin coconut oil for light greasing
For Lunu Miris: 3 tbsp whole dried chili flakes, 1 medium red shallot/onion, 1.5 tbsp Maldive fish flakes (umbalakada), 1.5 tbsp fresh lime juice, 1/2 tsp sea salt',
'Step 1: Aromatic Flour & Coconut Rub - In a wide earthenware bowl (chatti), combine the wheat flour, freshly scraped coconut, minced red onions, sliced green chilies, shredded curry leaves, and sea salt. Using your fingers, thoroughly rub the fresh coconut into the flour for 3 minutes; the natural moisture and aromatic coconut milk will begin to hydrate the starches and distribute herbal notes.
Step 2: Gradual Hydration & Dough Kneading - Make a well in the center of the flour mixture. Add lukewarm water gradually in small splashes while stirring with your fingers. Knead steadily for 4-5 minutes until a soft, pliable, cohesive dough forms that pulls away cleanly from the bowl without sticking to your hands.
Step 3: Portioning & Dough Relaxation - Divide the prepared dough into 6 equal, smooth spherical balls (approx. 100g each). Place on a tray, brush lightly with coconut oil, cover with a damp kitchen towel, and let rest for 10 minutes to allow the gluten network to relax for effortless flattening.
Step 4: Traditional Leaf Flattening - Lightly grease a square of clean banana leaf (or parchment paper) with coconut oil. Place a dough ball in the center. Using greased fingertips, press and expand the dough outward in a rhythmic circular pattern until it forms an even disc approximately 5 to 6 inches in diameter and 1/4-inch thick. Use a fork or finger to make 2 small indentations in the center to prevent uneven puffing.
Step 5: Cast-Iron Dry Roasting - Heat a heavy, ungreased cast-iron tawa, griddle, or skillet over medium-high heat until hot. Invert the banana leaf to drop the roti disc smoothly onto the dry hot griddle; peel off the leaf.
Step 6: Developing Toasted Char Spots - Roast the roti undisturbed for 3 to 4 minutes. Press down gently with a clean folded cloth or flat wooden press. Flip the roti and roast the reverse side for another 3 minutes until both sides develop characteristic golden-brown blistered char spots and the internal crumb is fully cooked and fragrant.
Step 7: Stone-Grinding the Lunu Miris - On a traditional Sri Lankan granite grinding stone (miris gala) or in a heavy stone mortar, crush the dried chili flakes and sea salt together into a coarse rub. Add the red onions and Maldive fish flakes; crush firmly with the pestle until a textured, moist, ruby-red paste forms. Fold in freshly squeezed lime juice to brighten the pungency.
Step 8: Traditional Table Presentation - Wrap the smoking-hot Pol Roti in a clean woven basket lined with a banana leaf or linen cloth. Serve immediately alongside a generous dish of freshly pounded Lunu Miris and a slab of creamy butter.',
'assets/images/recipes/sri-lankan-hoppers.jpg'),

(4, 4, 'Mumbai Street-Style Egg Bhurji (Spiced Masala Scramble)', 'Breakfast', 'India (Maharashtra, Mumbai)', 15,
'5 farm-fresh large Grade A eggs
2 tbsp unsalted Amul butter or pure cow ghee
1 tbsp neutral high-smoke cooking oil
1 tsp whole cumin seeds (jeera)
1 large yellow onion (finely brunoised)
2 fresh green bird''s eye chilies (finely minced)
1 tbsp fresh ginger-garlic paste (mortar pounded)
2 ripe red plum tomatoes (finely diced)
1/2 tsp ground turmeric
1 tsp Kashmiri red chili powder (for vibrant crimson color without harsh heat)
1 tsp ground coriander (dhania powder)
1/2 tsp authentic royal garam masala
1/2 cup fresh cilantro leaves (finely chopped)
Fine sea salt to taste and toasted buttered pav buns for serving',
'Step 1: Whisking the Egg Base - In a clean glass bowl, crack all 5 eggs. Add 1/2 teaspoon fine sea salt and 2 tablespoons cold water (the water turns to steam in the hot pan, yielding lighter curds). Whisk lightly with a fork for exactly 30 seconds until whites and yolks are just blended; avoid vigorous beating to preserve rich curd texture.
Step 2: Tempering Whole Spices - Place a wide, heavy-bottomed carbon-steel skillet or tawa over medium heat. Add 1 tablespoon neutral oil and 1 tablespoon butter. When the butter melts and foams, add whole cumin seeds. Let the seeds sizzle and bloom for 15 seconds until aromatic and nutty brown.
Step 3: Sautéing the Allium Base - Add the finely diced onions and green chilies. Sauté continuously over medium heat for 4-5 minutes, stirring to prevent burning, until the onions soften, become translucent, and develop delicate golden edges.
Step 4: Cooking Out Aromatics - Add the freshly pounded ginger-garlic paste. Cook for 60 seconds, stirring constantly, until the raw, sharp allium pungency dissipates into a mellow, sweet fragrance.
Step 5: Building the Tomato Masala Gravy - Stir in the diced plum tomatoes, ground turmeric, Kashmiri chili powder, ground coriander, and 1/2 teaspoon salt. Cook down over medium heat for 3-4 minutes, pressing down on the tomatoes with the back of a wooden spatula until they break down into a luscious, jammy masala that releases golden oil droplets along the pan edges.
Step 6: Soft Scramble Culinary Execution - Turn the heat down to low. Add the remaining tablespoon of cold butter into the center of the pan. Pour in the whisked eggs. Let the eggs sit undisturbed for 10 seconds to set the base layer.
Step 7: Curd Formation & Heat Management - Using a wooden spoon or silicone spatula, draw the cooked egg curds gently from the outer perimeter toward the center. Continue folding slowly in sweeping motions over gentle heat for 90 seconds. Crucial technique: remove the pan from heat while the curds are still glossy, moist, and soft-set; residual pan heat will complete the cooking without drying out the eggs.
Step 8: Herb Infusion & Street Pav Service - Immediately fold in the aromatic garam masala and freshly chopped cilantro. Transfer piping-hot to warm plates alongside split, toasted pav buns slathered with salted butter and a wedge of fresh lime.',
'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?auto=format&fit=crop&w=1000&q=80'),

(5, 20, 'Authentic Belgian Liège Waffles with Pearl Sugar', 'Breakfast', 'Belgium (Liège, Wallonia)', 30,
'3.5 cups unbleached high-protein bread flour (approx. 450g)
1 packet (7g) active dry yeast
1/3 cup lukewarm whole milk (strictly 105°F / 40°C)
2 tbsp light brown cane sugar
3 large farm-fresh eggs (room temperature)
1 tsp pure vanilla bean paste
1/2 tsp fine sea salt
1 cup unsalted European high-fat butter (82% butterfat, softened at room temp)
1 cup authentic Belgian pearl sugar (coarse sugar nibs, size C40)',
'Step 1: Yeast Activation & Proofing - In a small ceramic bowl, whisk active dry yeast and brown sugar into the lukewarm whole milk. Let sit undisturbed in a warm draft-free area for 8-10 minutes until a thick, frothy, yeasty foam rises to the surface, signaling robust viability.
Step 2: Dough Mixing Phase - In the bowl of a stand mixer fitted with the dough hook, combine the bread flour and fine sea salt. Pour in the foamy activated yeast mixture, room-temperature eggs, and vanilla bean paste. Knead on low speed for 3 minutes until a shaggy, cohesive dough begins to wrap around the hook.
Step 3: Butter Lamination Emulsion - With the mixer running on medium-low speed, incorporate the softened European butter one tablespoon at a time. Ensure each portion of butter is fully absorbed into the dough before adding the next. Once all butter is added, increase speed to medium and knead for 6-7 minutes until the dough becomes extraordinarily silky, glossy, elastic, and clears the sides of the bowl.
Step 4: Primary Bulk Fermentation - Scrape the rich, brioche-like dough into a lightly oiled glass bowl. Cover tightly with plastic wrap and let ferment in a warm location (approx. 78°F / 25°C) for 60 to 75 minutes until doubled in volume.
Step 5: Pearl Sugar Incorporation - Gently punch down the fermented dough onto a lightly floured surface. Scatter the authentic Belgian pearl sugar nibs across the dough. Knead gently by hand for 60 seconds just until the sugar pearls are distributed evenly throughout the matrix without crushing the nibs.
Step 6: Portioning & Bench Rest - Divide the dough with a bench knife into 8 equal oval portions (approx. 110g each). Shape each portion into a rough oval, place on a parchment-lined baking sheet, cover loosely with a cloth, and let rest for 15 minutes.
Step 7: Waffle Iron Calibration & Baking - Preheat a heavy cast-iron Belgian waffle maker (with deep 4x7 grid pockets) to medium-low heat (approx. 360°F / 180°C). Place one dough portion in the center of each grid. Close the lid gently without pressing. Bake for 3.5 to 4 minutes: the pearl sugar on the exterior will melt, bubble, and caramelize into a shiny, crackling, molasses-scented caramel shell, while the interior crumb bakes into a buttery brioche.
Step 8: Resting & Sugar Shell Setting - Use heatproof tongs or a waffle fork to transfer waffles to a wire cooling rack. Allow to rest for 90 seconds; this crucial pause allows the molten sugar caramel coating to cool and harden into its signature shatteringly crisp shell. Serve warm as is, or with fresh strawberries.',
'https://images.unsplash.com/photo-1562376552-0d160a2f238d?auto=format&fit=crop&w=1000&q=80'),

(6, 13, 'Brioche French Toast with Caramelized Bananas & Maple Butter', 'Breakfast', 'France (Pain Perdu Tradition)', 20,
'4 thick-cut (1.25-inch) slices day-old all-butter artisanal brioche loaf
3 large Grade A eggs
3/4 cup whole milk
1/4 cup heavy whipping cream (36% fat)
1.5 tbsp dark Muscovado sugar
1 tsp ground Ceylon cinnamon
1/4 tsp freshly grated nutmeg
1.5 tsp vanilla bean paste
3 tbsp European cultured unsalted butter
For Caramelized Bananas: 2 firm ripe bananas (sliced 1/2-inch thick on a bias), 2 tbsp unsalted butter, 3 tbsp pure Grade-A maple syrup, 1 tbsp dark aged rum (optional), pinch of sea salt',
'Step 1: Staling the Brioche Crumb - Slice day-old brioche loaf into thick 1.25-inch slabs. If the bread is freshly baked, arrange slices on a wire rack and dry in a 250°F (120°C) oven for 10 minutes; slightly dehydrated bread absorbs custard deeply like a sponge without falling apart.
Step 2: Preparing the Custard Royale - In a wide, shallow glass baking dish, vigorously whisk together eggs, whole milk, heavy cream, dark Muscovado sugar, Ceylon cinnamon, freshly grated nutmeg, vanilla bean paste, and a pinch of salt until the sugar is fully dissolved and the custard is velvety and uniform.
Step 3: Deep Custard Soaking - Submerge the brioche slices into the custard. Allow them to soak for exactly 60 seconds on the first side, then turn carefully with a wide spatula and soak for another 60 seconds. The interior of the brioche should be saturated with custard all the way to the core.
Step 4: Griddle Sear & Caramelization - Melt 2 tablespoons of cultured butter in a 12-inch heavy cast-iron skillet over medium heat until foaming and lightly golden. Lift brioche slices, let excess custard drain off for 3 seconds, and lay them into the hot skillet.
Step 5: Dual-Sided Baking - Cook undisturbed for 3.5 to 4 minutes on the first side over steady medium heat until a deep golden-brown, caramelized exterior crust develops. Carefully flip and cook the reverse side for 3 minutes until puffed, springy, and heated through to an internal temperature of 160°F (71°C).
Step 6: Sautéing Caramelized Bananas - Simultaneously in a separate non-stick skillet over medium-high heat, melt 2 tablespoons butter and 3 tablespoons pure maple syrup. When bubbling rapidly, add sliced banana coins in a single layer. Sear undisturbed for 90 seconds until the underside caramelizes, flip gently, and sear 60 seconds more.
Step 7: Flambé Deglaze - Pour in aged dark rum (if using); tilt the pan toward the gas flame or ignite with a long lighter to burn off raw alcohol, swirling for 30 seconds as the sauce reduces into a fragrant, glossy amber toffee glaze.
Step 8: Plating & Service - Plate the golden brioche French toast diagonally. Spoon the glistening warm caramelized bananas and buttery rum-maple syrup over top. Dust with powdered sugar through a fine sieve and serve warm.',
'https://images.unsplash.com/photo-1484723091739-30a097e8f929?auto=format&fit=crop&w=1000&q=80'),

(7, 21, 'Classic French Omelette aux Champignons, Épinards et Féta', 'Breakfast', 'France', 15,
'3 farm-fresh Grade A large eggs (strictly room temperature)
1.5 tbsp cultured French unsalted butter (beurre de baratte)
1/2 cup Cremini button mushrooms (thinly sliced)
1.5 cups fresh organic baby spinach leaves (washed and thoroughly dried)
1 small clove garlic (finely minced)
40g authentic Greek barrel-aged feta cheese (crumbled)
1 tbsp finely minced fresh French herbs (chives, tarragon, chervil)
Fine sea salt and freshly cracked white pepper',
'Step 1: Sautéing the Mushroom Filling - Heat 1/2 teaspoon of butter in an 8-inch non-stick skillet over medium-high heat. Add the sliced Cremini mushrooms in a single layer. Sear undisturbed for 2 minutes to drive off surface moisture and develop deep golden-brown edges. Add minced garlic and sauté for 30 seconds.
Step 2: Wilting Spinach & Moisture Extraction - Add baby spinach leaves to the mushrooms. Toss for 60 seconds until completely wilted and reduced in volume. Season with a tiny pinch of salt and white pepper. Immediately transfer the cooked filling to a warm plate lined with paper towels to drain any excess liquid that would dilute the omelette.
Step 3: Egg Homogenization - Wipe out the skillet with a clean cloth. In a ceramic bowl, beat the 3 room-temperature eggs with a fork for 45 seconds until whites and yolks are fully homogenized without creating surface foam. Season with a pinch of fine sea salt and white pepper.
Step 4: Conditioning the Skillet - Place the skillet over medium-low heat. Add 1 tablespoon of cultured butter. Swirl the pan as the butter melts, foams, and coats the entire surface and sides; do not allow the butter to brown (a classic French omelette must remain pale yellow with zero browning).
Step 5: The High-Speed Agitation (Baveuse Technique) - Pour the beaten eggs into the foaming butter. Immediately begin shaking the pan vigorously back and forth with your non-dominant hand while rapidly stirring the eggs in circular motions with a heatproof silicone spatula in your dominant hand. This breaks up curds into fine, microscopic scrambled ribbons.
Step 6: Setting the Base - When the eggs resemble soft, creamy, custard-like curds (approx. 90 seconds) and the surface is still moist and slightly glossy (baveuse stage), smooth the top flat with the spatula and remove the pan completely from heat.
Step 7: Layering the Filling - Scatter the warm sautéed mushrooms, wilted spinach, and crumbled feta cheese in a neat, straight horizontal line across the center third of the omelette.
Step 8: Folding & Glossy Butter Glaze - Tilt the skillet forward at a 45-degree angle. Using the spatula, gently fold the top third of the egg sheet downward over the filling. Tap the pan handle with your wrist to encourage the far edge to curl upward, then roll the omelette into an elegant, smooth, cigar-like spindle. Invert onto a warm serving plate with the seam hidden underneath. Immediately rub the exterior surface with a cold pat of butter for a mirror-like shine, scatter with fresh herbs, and serve.',
'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/Spinach_mushroom_omelet.jpg/960px-Spinach_mushroom_omelet.jpg'),

(8, 14, 'Traditional Sri Lankan String Hoppers (Idiyappam) with Kiri Hodi & Pol Sambol', 'Breakfast', 'Sri Lanka', 45,
'2.5 cups fine roasted red or white raw rice flour (idiyappam piti)
1 tsp fine sea salt
1.5 to 2 cups bubbling boiling water
For Kiri Hodi: 1.5 cups thin coconut milk, 1/2 cup thick first-press coconut cream, 1/2 small red onion (sliced), 2 green chilies (slit), 1 sprig curry leaves, 1/2 tsp fenugreek seeds (uluhal), 1/4 tsp ground turmeric, 1 small piece cinnamon quill, 1 tbsp fresh lime juice, salt to taste
Traditional woven cane string hopper mats (thatte) & brass extruder press (wangediya)',
'Step 1: Flour Seasoning - In a heatproof earthenware or stainless steel mixing bowl, combine fine roasted red rice flour and fine sea salt. Whisk to blend.
Step 2: Hydration with Boiling Water - Bring filtered water to a vigorous, bubbling boil. Gradually pour 1.5 cups of boiling water into the flour while stirring continuously with a sturdy wooden spoon until the flour begins to hydrate and clump together.
Step 3: Kneading the Pliable Dough - Allow the mixture to cool for 2 minutes until safe to handle. Knead vigorously with your palms for 3 minutes into a smooth, non-sticky, pliable dough that easily holds its shape. Keep covered with a damp cloth to prevent drying.
Step 4: Extruder Press Loading - Fill the cylinder of a traditional brass or stainless-steel Idiyappam press with dough. Lightly mist the woven bamboo string hopper mats (thatte) with coconut oil.
Step 5: Circular Noodle Extrusion - Hold the press 2 inches above a mat. Squeeze the handles firmly while moving the press in a continuous, smooth circular motion, weaving fine, lace-like vermicelli coils into a neat 4-inch round nest.
Step 6: High-Steam Cooking - Arrange the loaded mats into a multi-tiered bamboo or stainless steel steamer over vigorously boiling water. Steam over high heat for exactly 5 to 6 minutes until the noodles are firm, dry to the touch, and translucent.
Step 7: Preparing the Kiri Hodi Gravy - In a clay pot, combine thin coconut milk, sliced red onions, green chilies, curry leaves, fenugreek seeds, turmeric, cinnamon quill, and salt. Simmer over medium heat for 7 minutes to infuse spices. Stir in thick coconut cream; cook over low heat for 2 minutes, stirring gently to prevent curdling. Remove from heat and stir in fresh lime juice.
Step 8: Serving the Feast - Invert the steamed mats onto a serving platter; the delicate string hopper nests will release cleanly. Serve with warm, fragrant Kiri Hodi and freshly prepared spicy coconut Pol Sambol.',
'assets/images/recipes/sri-lankan-string-hoppers.jpg'),

(9, 26, 'Traditional Middle Eastern Shakshuka with Feta & Sourdough', 'Breakfast', 'North Africa & Levant (Tunisia)', 30,
'4 large fresh Grade A eggs
3 tbsp extra virgin olive oil
1 large yellow onion (finely diced)
1 red bell pepper & 1 yellow bell pepper (cored and diced 1/2-inch)
4 cloves fresh garlic (thinly sliced)
1.5 tsp ground cumin & 1.5 tsp smoked Spanish paprika
1/2 tsp ground coriander & 1/4 tsp cayenne pepper
1 can (14 oz / 400g) whole San Marzano plum tomatoes (crushed by hand with juice)
1 tbsp tomato paste
70g authentic Greek sheep''s milk feta cheese (crumbled)
1/4 cup fresh cilantro & 1/4 cup flat-leaf parsley (roughly chopped)
Warm toasted sourdough slices for serving',
'Step 1: Searing Aromatics in Cast-Iron - Heat extra virgin olive oil in a wide 10-inch heavy cast-iron skillet over medium heat until shimmering. Add the diced onions and bell peppers. Sauté for 8-10 minutes, stirring occasionally, until vegetables soften, sweeten, and develop light caramelized golden edges.
Step 2: Toasting Spices in Hot Oil - Add sliced garlic, tomato paste, ground cumin, smoked paprika, ground coriander, and cayenne pepper. Sauté for 90 seconds; the direct contact with hot oil blooms the fat-soluble spices, releasing an intoxicating earthy fragrance.
Step 3: Tomato Reduction & Fond Extraction - Pour in the hand-crushed San Marzano tomatoes with their rich juices. Season with 3/4 tsp sea salt and freshly cracked black pepper. Reduce heat to medium-low and simmer uncovered for 12 to 15 minutes, stirring occasionally until the sauce thickens into a rich, deep crimson, stew-like consistency.
Step 4: Indenting the Wells - Taste and adjust seasoning. Using the back of a large metal spoon, create 4 deep, well-spaced indentations in the bubbling tomato-pepper sauce.
Step 5: Cracking the Eggs - Gently crack one egg directly into each indentation. Season each egg white with a tiny pinch of fine salt.
Step 6: Cheese Dispersion - Scatter the crumbled Greek sheep''s milk feta cheese generously over the bubbling sauce around the eggs (the feta will soften and warm without fully melting).
Step 7: Covered Gentle Poach - Cover the skillet with a tight lid. Cook over low heat for 5 to 7 minutes. Monitor carefully: remove the lid when the egg whites are fully opaque and set, while the golden yolks remain runny and trembling.
Step 8: Herb Crown & Skillet Service - Remove from heat immediately. Scatter fresh cilantro and flat-leaf parsley across the skillet. Drizzle with a thin ribbon of extra virgin olive oil and serve bubbling hot straight from the cast-iron skillet with thick, warm slices of toasted sourdough.',
'https://images.unsplash.com/photo-1590301157890-4810ed352733?auto=format&fit=crop&w=1000&q=80'),

(10, 29, 'Brazilian Açaí Na Tigela Bowl with Fresh Berries & Granola', 'Breakfast', 'Brazil (Amazon Basin, Pará)', 10,
'2 packets (200g total) pure unsweetened organic frozen açaí berry pulp
1 large frozen banana (peeled and sliced before freezing)
1/2 cup frozen organic wild blueberries
1/4 cup unsweetened almond milk or coconut water
1 tbsp raw organic honey or pure maple syrup
Toppings: 1/3 cup artisanal almond-pecan granola, 1/2 fresh banana (sliced on bias), 1/4 cup fresh strawberries (quartered), 2 tbsp fresh blueberries, 1 tbsp chia seeds, 1 tbsp toasted unsweetened coconut flakes',
'Step 1: Tempering Frozen Fruit - Run the sealed frozen açaí packets under lukewarm tap water for 5-8 seconds to loosen the plastic wrap, then break the pulp into 4-5 chunks by hand before opening.
Step 2: Loading the Blender - Place the broken açaí chunks, frozen banana slices, frozen wild blueberries, and raw honey into the pitcher of a high-powered commercial blender (such as a Vitamix).
Step 3: Minimal Liquid Addition - Add just 1/4 cup of almond milk or coconut water. Adding too much liquid results in a thin drink; keeping liquid to a minimum produces the thick, scoopable sorbet consistency characteristic of Brazilian beach kiosks.
Step 4: High-Speed Tamper Emulsification - Start the blender on low speed, then ramp up to maximum high. Use the tamper tool vigorously to push frozen ingredients down into the spinning blades, blending for 45-60 seconds until a velvety, thick, deep purple sorbet with four distinct vortex mounds forms.
Step 5: Chilled Bowl Preparation - Chill wide ceramic bowls in the freezer for 10 minutes prior to plating to prevent premature melting.
Step 6: Sorbet Portioning - Spoon the thick, frosty açaí purée immediately into the chilled bowls, smoothing the surface with the back of a spoon.
Step 7: Artisanal Granola Stripe - Arrange the crunchy almond-pecan granola in a crisp, neat diagonal stripe across the surface.
Step 8: Fresh Fruit Layout - Fan out fresh banana slices and quartered strawberries in parallel rows, scatter blueberries, and finish with chia seeds and toasted coconut flakes. Serve immediately.',
'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?auto=format&fit=crop&w=1000&q=80'),

(11, 6, 'California Breakfast Burrito with Chorizo, Crispy Hash Browns & Salsa Fresca', 'Breakfast', 'United States (San Diego, California)', 25,
'2 extra-large (12-inch) fresh flour tortillas
150g Mexican pork chorizo (casing removed)
1.5 cups shredded Russet potatoes (rinsed thoroughly in cold water and squeezed bone-dry)
4 large farm-fresh eggs
2 tbsp whole milk
1 tbsp unsalted butter
1 cup shredded Monterey Jack & sharp Cheddar cheese blend
1 ripe Hass avocado (diced)
1/2 cup fresh Pico de Gallo (diced plum tomatoes, white onion, jalapeño, cilantro, lime juice)
2 tbsp Mexican crema or sour cream
Fine sea salt and cracked black pepper',
'Step 1: Rendering & Browning the Chorizo - Heat a 10-inch cast-iron skillet over medium heat. Add the crumbled chorizo and cook for 6-7 minutes, breaking it into small bits with a wooden spatula until browned, crispy, and the fragrant red spiced fat renders. Transfer chorizo to a plate with a slotted spoon, reserving the flavorful rendered drippings in the skillet.
Step 2: Shatteringly Crisp Hash Browns - Spread the dried shredded Russet potatoes in an even layer across the skillet in the hot chorizo drippings. Press down firmly with a spatula. Cook undisturbed over medium-high heat for 5 minutes until a deep golden, crispy bottom crust forms. Flip and crisp the reverse side for 3 minutes. Season with sea salt and transfer to a cutting board.
Step 3: Creamy Scrambled Egg Preparation - In a bowl, whisk eggs with milk, a pinch of salt, and black pepper. Melt butter in a non-stick pan over medium-low heat. Add eggs and cook gently for 90 seconds, stirring in broad sweeps until soft, moist, creamy curds form. Remove from heat while still glossy.
Step 4: Conditioning the Flour Tortilla - Warm each large flour tortilla on a dry flat griddle for 20 seconds per side until soft, pliable, and lightly puffed.
Step 5: Layering for Structural Integrity - Lay the warm tortilla flat. Scatter half of the shredded cheese across the center third (melting against the warm tortilla creates a protective moisture barrier). Layer on the warm scrambled eggs, cooked chorizo, and crispy hash browns.
Step 6: Fresh Condiments - Top with diced avocado, freshly drained Pico de Gallo, and a drizzle of Mexican crema.
Step 7: The Master Burrito Roll - Fold the left and right sides of the tortilla inward over the filling. Fold the bottom flap up and over the filling, pull back gently to compact ingredients tightly, and roll forward into a neat, secure cylinder.
Step 8: Plancha Toasting - Place the rolled burrito seam-side down onto the hot dry griddle. Toast for 2 minutes per side until golden brown, crispy, and sealed. Slice diagonally and serve with extra salsa.',
'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?auto=format&fit=crop&w=1000&q=80'),

(12, 8, 'Coconut Vanilla Chia Seed Pudding with Fresh Berry Compote', 'Breakfast', 'Mexico & Central America', 10,
'1/2 cup organic black chia seeds
1.5 cups full-fat unsweetened coconut milk (canned, whisked smooth)
1/2 cup unsweetened almond milk
2 tbsp pure Grade-A maple syrup or raw agave nectar
1 tsp pure vanilla bean extract or paste
1/4 tsp ground Ceylon cinnamon
Pinch of fine sea salt
For Berry Compote: 1.5 cups fresh raspberries and blackberries, 1 tbsp fresh lemon juice, 1 tbsp maple syrup, fresh mint leaves',
'Step 1: Whisking Liquid Emulsion - In a 1-quart glass measuring pitcher, whisk together the full-fat coconut milk, almond milk, maple syrup, vanilla bean paste, cinnamon, and sea salt until smooth and uniform.
Step 2: Dispersing Chia Seeds - Add the black chia seeds to the liquid. Whisk vigorously with a balloon whisk for 60 seconds to ensure the seeds are suspended throughout the liquid without sinking into a dense clump.
Step 3: The Intermittent Rest & Re-whisk - Allow the mixture to sit at room temperature for 10 minutes. As the hydrophilic mucilage on the chia seed coats begins to absorb moisture, whisk vigorously once more for 30 seconds to break up any settling seeds.
Step 4: Overnight Chilled Hydration - Pour into a sealed mason jar or glass bowl. Refrigerate for at least 4 hours, or ideally overnight (8-12 hours); the chia seeds will absorb four times their weight in liquid, creating a thick, luxurious, tapioca-like pudding.
Step 5: Simmering the Fresh Berry Compote - In a small saucepan over medium-low heat, combine fresh raspberries, blackberries, lemon juice, and maple syrup. Cook for 5-6 minutes, crushing half of the berries with a wooden spoon until a glossy, thick compote forms.
Step 6: Compote Reduction & Cooling - Remove compote from heat and stir in vanilla extract. Allow to cool completely to room temperature, then chill in refrigerator for 20 minutes to set the natural fruit pectins.
Step 7: Parfait Layering - In chilled glass dessert tumblers, layer alternating spoonfuls of chilled coconut chia pudding and vibrant berry compote.
Step 8: Garnishing & Presentation - Crown each parfait with fresh whole berries, toasted coconut chips, and a sprig of fresh mint. Serve chilled with a long spoon.',
'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Chia_Seed_Pudding.jpg/960px-Chia_Seed_Pudding.jpg'),

(13, 1, 'Traditional Crispy Corned Beef Hash with Sunny-Side Eggs', 'Breakfast', 'United Kingdom & United States', 30,
'350g cooked corned beef brisket (finely diced into 1/4-inch cubes)
2 large Yukon Gold potatoes (boiled in salted water, peeled, and diced 1/4-inch)
1 medium yellow onion (finely diced)
1/2 red bell pepper (finely diced)
2 tbsp European unsalted butter
1 tbsp neutral cooking oil
1 tbsp Worcestershire sauce
1/2 tsp smoked paprika & 1/4 tsp dried thyme
4 large farm-fresh eggs
Freshly cracked black pepper and chopped chives for garnish',
'Step 1: Pre-cooking & Cubing Potatoes - Boil Yukon Gold potatoes in well-salted water until just knife-tender (avoid over-boiling to prevent mushiness). Cool, peel, and cut into uniform 1/4-inch dice.
Step 2: Sautéing Aromatics - Heat 1 tablespoon butter and 1 tablespoon oil in a 12-inch heavy cast-iron skillet over medium heat. Add diced onions and bell peppers; sauté for 5 minutes until soft, sweet, and golden.
Step 3: Seasoning the Hash Mixture - In a bowl, toss diced corned beef, diced potatoes, Worcestershire sauce, smoked paprika, dried thyme, and black pepper.
Step 4: Pressing the Hash - Add the corned beef and potato mixture to the skillet with the sautéed onions. Spread into an even, flat layer. Using the back of a wide, heavy metal spatula, press the mixture firmly against the bottom of the skillet to ensure complete surface contact.
Step 5: Developing the Golden Crust - Cook undisturbed over medium heat for 7-8 minutes. Listen for a steady sizzling crackle: cook until a deep mahogany-brown, crispy crust forms on the bottom.
Step 6: Turning & Second Sear - Using your spatula, flip the hash in sections. Press down firmly again and cook undisturbed for another 5-6 minutes until the second side is equally browned and crispy.
Step 7: Frying Sunny-Side Eggs - In a separate non-stick pan, melt 1 tablespoon butter over medium-low heat. Crack 4 eggs gently. Fry slowly for 3 minutes until whites are completely set and opaque, while the yolks remain runny, liquid, and bright orange.
Step 8: Assembling & Garnish - Divide crispy corned beef hash onto warm plates. Top each portion with a sunny-side-up egg, sprinkle with flaky sea salt and cracked black pepper, and scatter fresh chives over top.',
'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=1000&q=80'),

(14, 20, 'Classic Parisian Crêpes with Hazelnut Gianduja & Sliced Bananas', 'Breakfast', 'France (Brittany & Paris)', 25,
'1 cup unbleached all-purpose flour (sifted)
2 large Grade A eggs (room temperature)
1.25 cups whole milk (warmed to 100°F / 38°C)
2 tbsp unsalted European butter (melted and slightly browned, beurre noisette)
1 tbsp superfine baker''s sugar
1 tsp pure vanilla bean extract
Pinch of fine sea salt
Filling: 1/2 cup artisanal hazelnut cocoa spread (Gianduja or Nutella), 2 ripe bananas (thinly sliced on bias), 1/4 cup toasted sliced almonds, confectioners'' sugar for dusting',
'Step 1: Blender Emulsification - In a high-speed blender, combine the sifted flour, eggs, warm whole milk, browned butter (beurre noisette), sugar, vanilla extract, and salt. Blend on high speed for 20 seconds, scrape down sides, and blend for 10 seconds more until completely smooth with the consistency of light heavy cream.
Step 2: Crucial Batter Rest - Strain the crêpe batter through a fine-mesh sieve into a pitcher. Cover and refrigerate for at least 30 minutes (or up to 2 hours); this rest relaxes the gluten strands and lets air bubbles dissipate, ensuring paper-thin, tender crêpes that do not tear.
Step 3: Conditioning the Crêpe Pan - Heat an 8-inch non-stick crêpe pan or seasoned blue-steel pan over medium heat. Lightly brush with melted butter, wiping away excess with a paper towel.
Step 4: The Swirl Technique - Lift the pan off the heat with your wrist tilted at a 45-degree angle. Pour 3 tablespoons (approx. 1/4 cup) of batter into the center while simultaneously swirling the pan in a swift, continuous circular motion so the batter coats the entire bottom in a micro-thin, translucent layer.
Step 5: Quick Sear - Return the pan to medium heat. Cook undisturbed for 60 to 75 seconds until the edges curl up, turn lacy and crisp, and the underside is speckled golden brown.
Step 6: Delicate Flip - Loosen the edges with a thin silicone spatula. Use your fingertips or spatula to flip the crêpe smoothly. Cook the reverse side for just 25-30 seconds.
Step 7: Spreading Gianduja & Folding - While still warm on the pan (or transferred to a plate), spread 2 tablespoons of hazelnut gianduja spread across one half of the crêpe and arrange banana slices on top. Fold the crêpe in half, then into quarters to form the traditional Parisian triangle.
Step 8: Patisserie Finish - Arrange two folded crêpes on a dessert plate. Garnish with toasted sliced almonds and dust with confectioners'' sugar through a fine sieve. Serve warm.',
'https://images.unsplash.com/photo-1519676867240-f03562e64548?auto=format&fit=crop&w=1000&q=80'),

(15, 6, 'Southwestern Breakfast Quesadilla with Scrambled Eggs & Queso Oaxaca', 'Breakfast', 'Mexico (Oaxaca & Sonora)', 15,
'2 large (10-inch) flour tortillas
4 large farm-fresh eggs
1 tbsp unsalted butter
1/2 cup cooked black beans (drained and seasoned with cumin)
1/4 cup fire-roasted sweet corn kernels
1.25 cups authentic Queso Oaxaca (shredded) or blend of Monterey Jack and Asadero
2 scallions (thinly sliced)
2 tbsp fresh cilantro (chopped)
1/4 tsp ground cumin, sea salt, and black pepper
Fresh guacamole, salsa verde, and Mexican crema for serving',
'Step 1: Scrambling Eggs Gently - In a bowl, whisk eggs with ground cumin, salt, and pepper. Melt butter in a non-stick skillet over medium-low heat. Add eggs and gently scramble for 90 seconds until soft, moist, and custard-like; remove from heat while still slightly wet.
Step 2: Griddle Preheating - Preheat a wide, heavy flat cast-iron griddle or comal over medium heat. Brush lightly with melted butter or neutral oil.
Step 3: Foundation Cheese Layer - Lay one large flour tortilla flat onto the warm griddle. Evenly distribute half of the shredded Queso Oaxaca across the entire surface; melting cheese on the bottom anchors the fillings and bonds the tortillas.
Step 4: Distributing Warm Fillings - Scatter the soft scrambled eggs, seasoned black beans, fire-roasted corn, sliced scallions, and chopped cilantro evenly over the cheese.
Step 5: Top Cheese Seal & Tortilla Cap - Cover fillings with the remaining shredded Queso Oaxaca. Lay the second flour tortilla squarely on top. Press down firmly with the palm of your hand or a flat grill press.
Step 6: First Side Golden Toasting - Cook for 3-4 minutes over steady medium heat. Check the bottom: cook until the lower tortilla is crisp, blistered with golden-brown spots, and the lower cheese layer is fully melted.
Step 7: The Confident Flip - Slide a wide spatula under the quesadilla, place your free hand lightly on top, and flip decisively. Cook the second side for 2-3 minutes until equally crisp, golden, and cheese is thoroughly melted and bubbly.
Step 8: Resting & Slicing - Slide quesadilla onto a cutting board. Rest for 60 seconds to allow the melted cheese to stabilize. Cut into 6 triangular wedges with a chef''s knife or pizza wheel. Serve with fresh guacamole, salsa verde, and crema.',
'assets/images/recipes/breakfast-quesadilla.jpg'),

(16, 17, 'Artisanal Eggs Benedict on Toasted English Muffin with Velvet Hollandaise', 'Breakfast', 'United States (New York City)', 20,
'2 artisanal English muffins (split with a fork)
4 thick slices Canadian bacon or smoked back ham
4 farm-fresh Grade A large eggs (chilled)
1 tbsp distilled white vinegar (for poaching water)
For Velvet Hollandaise: 3 large egg yolks, 1 tbsp freshly squeezed lemon juice, 1/2 cup unsalted European butter (melted and bubbling hot, approx. 180°F / 82°C), 1/4 tsp Dijon mustard, pinch of cayenne pepper, fine sea salt
Finely minced fresh chives and smoked paprika for garnish',
'Step 1: Blender Hollandaise Emulsion - Add egg yolks, fresh lemon juice, Dijon mustard, cayenne pepper, and a pinch of salt to a high-speed blender cup. Blend on medium speed for 10 seconds until pale and combined.
Step 2: Hot Butter Streaming Technique - With the blender running on medium speed, slowly stream in the bubbling-hot melted butter in a pencil-thin stream. The intense heat of the butter simultaneously pasteurizes and cooks the egg yolks while rapidly creating an ultra-velvety, thick, glossy warm emulsion. Transfer to a small thermos or keep warm in a water bath.
Step 3: Searing Canadian Bacon - Heat a skillet over medium-high heat. Sear Canadian bacon slices for 90 seconds per side until edges are caramelized, lightly browned, and heated through; keep warm.
Step 4: Water Bath Conditioning - Bring a deep pot of water to a gentle simmer (190°F / 88°C) with 1 tablespoon white vinegar. Strain chilled eggs individually in a fine mesh sieve to remove loose albumen, placing each in a small ramekin.
Step 5: Poaching Eggs to Liquid Center - Create a gentle vortex in the simmering water. Slip eggs in one by one. Poach undisturbed for exactly 3 minutes and 15 seconds until whites are firm and yolks remain warm and liquid. Remove with a slotted spoon and blot on paper towels.
Step 6: Fork-Splitting English Muffins - Split English muffins using a fork (fork-splitting preserves the nooks and crannies that hold hollandaise). Toast until craggy edges are deeply golden and crunchy; butter lightly.
Step 7: Structural Assembly - Place toasted muffin halves on warm plates. Lay a slice of seared Canadian bacon over each half, followed by a warm, blotted poached egg.
Step 8: Crown with Hollandaise - Ladle warm velvet Hollandaise generously over each poached egg, allowing it to cascade down the sides. Dust with fresh chives and smoked paprika; serve immediately.',
'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?auto=format&fit=crop&w=1000&q=80'),

(17, 13, 'Authentic Swiss Bircher Müesli with Grated Honeycrisp Apple & Hazelnuts', 'Breakfast', 'Switzerland (Zurich)', 15,
'1.5 cups traditional rolled whole grain oats
1 cup cold whole milk or oat milk
1/2 cup fresh unfiltered cloudy apple cider
1 cup plain whole-milk Swiss yogurt or Greek yogurt
2 tbsp pure raw wildflower honey
1 large crisp Honeycrisp or Granny Smith apple (unpeeled)
1/3 cup raw hazelnuts (toasted, skins rubbed off, and coarsely chopped)
1/4 cup golden sultana raisins
1/2 cup fresh wild raspberries
1 tbsp freshly squeezed lemon juice',
'Step 1: Oats & Liquid Inoculation - In a large glass or ceramic bowl, combine rolled whole grain oats, cold milk, fresh unfiltered cloudy apple cider, golden raisins, and raw wildflower honey. Stir thoroughly with a wooden spoon.
Step 2: Overnight Fermentation Soak - Cover the bowl with a tight lid or wrap and refrigerate for at least 4 hours, or ideally overnight (8-12 hours). During this slow cold soak, the oat starches and beta-glucan fibers hydrate, creating the signature velvety Swiss texture and unlocking subtle fermented oat complexities.
Step 3: Aerating with Swiss Yogurt - The following morning, stir in the creamy whole-milk yogurt, folding gently until the muesli becomes lush and creamy.
Step 4: Box-Grating Fresh Apple - Wash the crisp unpeeled apple. Using the large holes of a box grater, coarsely grate the entire apple (skin included, avoiding the core) directly into the bowl. Immediately drizzle with 1 tablespoon fresh lemon juice to preserve bright color.
Step 5: Folding Fruit & Grain - Fold the grated apple through the soaked oat mixture; the tart, crisp grated apple shreds provide the essential juicy freshness pioneered by Dr. Maximilian Bircher-Benner.
Step 6: Roasting Hazelnuts - In a dry skillet over medium heat, toast raw hazelnuts for 3-4 minutes until aromatic and skins blister. Wrap in a clean towel and rub vigorously to remove bitter outer skins, then chop coarsely.
Step 7: Portioning into Chilled Coupes - Spoon the creamy Bircher Müesli into chilled glass coupes or porcelain breakfast bowls.
Step 8: Alpine Garnish - Top each bowl with fresh wild raspberries, toasted crunchy hazelnuts, and a final drizzle of raw wildflower honey before serving.',
'https://images.unsplash.com/photo-1517673132405-a56a62b18caf?auto=format&fit=crop&w=1000&q=80'),

(18, 7, 'Authentic Sri Lankan Red Chicken Curry (Kukul Mas Kari)', 'Lunch', 'Sri Lanka (Central & Southern Provinces)', 45,
'850g bone-in country chicken thighs and drumsticks (cut into bite-sized curry portions)
3 tbsp pure virgin coconut oil
1 large red shallot or onion (finely sliced)
5 cloves garlic & 1.5-inch fresh ginger (mortar and pestle crushed into paste)
3 green bird''s eye chilies (slit lengthwise)
1 stalk lemongrass (bruised to release oils)
2 sprigs fresh curry leaves & 2-inch pandan leaf (rampe)
1 piece Ceylon cinnamon quill (true cinnamon) & 4 green cardamom pods
2.5 tbsp dark roasted Sri Lankan curry powder (badapu thuna paha)
1 tbsp unroasted raw curry powder
1 tbsp roasted chili powder (for deep crimson red tone)
1/2 tsp ground turmeric
1.5 tbsp wet tamarind pulp or 2 pieces dried garcinia (goraka)
1.25 cups thin coconut milk (second extract)
3/4 cup thick first-press coconut cream (miti kiri)
Coarse sea salt to taste',
'Step 1: Precision Poultry Prep & Meat Inoculation - Wash chicken pieces with water mixed with a pinch of turmeric and lime juice; drain thoroughly. In a traditional earthenware clay pot (wali athiliya) or heavy Dutch oven, combine the chicken pieces with roasted curry powder, unroasted curry powder, turmeric, roasted chili powder, crushed ginger-garlic paste, and 1.5 teaspoons coarse sea salt. Massage the spices vigorously into the meat fibers and crevices for 3 minutes, then allow to marinate at ambient temperature for 25 minutes.
Step 2: Aromatic Tempering (Theldala Foundation) - Set the clay pot over medium-high heat with virgin coconut oil. When the oil shimmers, add the sliced red shallots, slit green chilies, bruised lemongrass stalk, pandan leaf, cracked cardamom pods, and fresh curry leaves. Sauté continuously for 4-5 minutes until the shallots turn translucent with dark caramel edges and the volatile essential oils release an intoxicating Sri Lankan herbal fragrance.
Step 3: Maillard Browning & High-Heat Searing - Introduce the marinated chicken along with all accumulated spice juices into the sizzling pot. Crank the heat to high. Sear the chicken pieces undisturbed for 2 minutes, then stir-fry vigorously for 6-8 minutes until the exterior surface is lightly caramelized, sealing in intrinsic myoglobin juices and deepening the spice crust.
Step 4: Primary Liquid Extraction & Simmer - Dissolve the tamarind pulp or softened goraka pieces in the thin second-extract coconut milk. Pour the liquid around the edges of the pot to lift any caramelized fond stuck to the base. Bring the curry to a rolling boil over high heat.
Step 5: Low-Heat Covered Braise - Reduce the flame to low, cover the clay pot tightly with its terracotta lid, and let the curry simmer gently for 22 minutes. The bone marrow inside the chicken will render into the sauce, creating a complex, gelatin-rich body while keeping the meat meltingly tender.
Step 6: Enriching with First-Press Coconut Cream - Remove the lid. Pour in the rich, velvety thick first-press coconut cream (miti kiri) in a slow circle. Swirl the pot gently by its handles rather than stirring aggressively with a spoon to avoid breaking tender meat pieces.
Step 7: Sauce Reduction & Spiced Oil Splitting - Simmer uncovered on medium-low heat for 6 to 8 minutes. Watch for the hallmark culinary indicator: glistening beads of vibrant ruby-red spiced coconut oil will separate and float to the surface, signaling that the curry sauce has achieved proper nappe consistency.
Step 8: Resting Phase & Traditional Royal Service - Extinguish the heat, discard the spent lemongrass stalk, and let the curry rest undisturbed for 15 minutes to allow the spices to settle and deepen in harmony. Serve piping hot in earthenware dishes accompanied by steaming samba rice, pol sambol, and dhal curry.',
'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?auto=format&fit=crop&w=1000&q=80'),

(19, 17, 'Classic Chicken Caesar Salad with Anchovy Dressing & Brioche Croutons', 'Lunch', 'Mexico (Tijuana - Caesar''s Hotel, 1924)', 25,
'2 large boneless skinless chicken breasts (approx. 450g total)
2 crisp heads Romaine lettuce hearts (cold-water crisped, spun bone-dry, hand-torn)
For Authentic Emulsion Dressing: 3 oil-packed Italian anchovy fillets, 1 large garlic clove, 1 large egg yolk (room temperature), 1.5 tsp Dijon mustard, 2 tbsp fresh Meyer lemon juice, 1/2 tsp Worcestershire sauce, 1/2 cup cold-pressed extra virgin olive oil, 1/3 cup finely microplaned Parmigiano-Reggiano (24-month aged), fresh black pepper
For Golden Brioche Croutons: 2.5 cups crustless day-old brioche loaf (cubed 3/4-inch), 3 tbsp melted cultured butter, 1 tbsp olive oil, 1/2 tsp garlic powder, pinch of fine sea salt
Block of aged Parmigiano-Reggiano for shaved ribbons',
'Step 1: Cold Crisping the Romaine Hearts - Separate the Romaine leaves, submerge in an ice-water bath for 10 minutes to maximize cellular turgor pressure and crunch, spin completely dry in a salad spinner, and wrap in clean linen towels in the refrigerator. Moisture is the enemy of dressing adherence.
Step 2: Golden Brioche Crouton Toasting - Preheat oven to 375°F (190°C). In a large bowl, toss the brioche cubes with melted cultured butter, olive oil, garlic powder, and fine sea salt. Spread onto a parchment-lined half-sheet pan in a single layer. Bake for 9-11 minutes, tossing once halfway, until shatteringly crisp on the exterior with a delicate buttery core. Cool on a wire rack.
Step 3: Poultry Brining & Seasoning - Butterfly the chicken breasts horizontally for uniform thickness. Lightly brush with olive oil, Meyer lemon zest, cracked Tellicherry black pepper, and kosher salt. Allow the seasoned meat to sit for 10 minutes.
Step 4: Charcoal Pan Searing - Heat a heavy cast-iron grill pan or skillet over medium-high heat until smoking. Lay the chicken breasts down away from you. Sear undisturbed for 4.5 minutes to achieve dark, caramelized grill marks. Flip and cook for an additional 3.5 to 4 minutes until the thickest part registers exactly 160°F (71°C) on a digital probe. Transfer to a cutting board and rest for 5 minutes before slicing against the grain into 1/2-inch medallions.
Step 5: Stone Mortar Anchovy Paste - In a marble mortar or heavy wooden bowl, crush the anchovies, minced garlic clove, and a pinch of coarse sea salt with the pestle until a smooth, aromatic paste is achieved.
Step 6: Classical Caesar Emulsion - Whisk in the egg yolk, Dijon mustard, fresh lemon juice, and Worcestershire sauce until frothy and pale. While whisking continuously and vigorously, drizzle the extra virgin olive oil in a microscopic stream down the inner side of the bowl. The mixture will emulsify into a rich, glossy, mayonnaise-like dressing. Whisk in the microplaned Parmigiano-Reggiano and generous cracked black pepper.
Step 7: Leaf Coating & Toss Technique - Place the cold, bone-dry hand-torn Romaine hearts into a large chilled wooden salad bowl. Ladle two-thirds of the creamy emulsion around the walls of the bowl. Using chilled salad tongs or clean hands, gently lift and turn the greens until every leaf is enveloped in a gossamer, translucent film of savory dressing.
Step 8: Architectural Plating - Divide the dressed Romaine between chilled plates. Crown with the warm sliced chicken medallions and scatter the golden brioche croutons throughout. Using a vegetable peeler, drape wide ribbons of aged Parmigiano-Reggiano across the summit and crack fresh black pepper over the dish. Serve immediately.',
'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?auto=format&fit=crop&w=1000&q=80'),

(20, 2, 'Triple-Decker Club Sandwich with Roasted Turkey, Applewood Smoked Bacon & Herb Aioli', 'Lunch', 'United States (Saratoga Springs, New York)', 20,
'3 thick slices artisanal white Pullman brioche bread
180g herb-roasted deli turkey breast (sliced thin and shaved)
4 strips thick-cut Applewood smoked bacon
2 large leaves crisp butterhead or romaine lettuce (washed and dried)
2 thick slices vine-ripened beefsteak tomato (at room temperature)
For Meyer Lemon Herb Aioli: 4 tbsp whole-egg emulsion mayonnaise, 1/2 tsp Dijon mustard, 1 tsp fresh Meyer lemon juice, 1 clove garlic (grated), 1 tbsp minced fresh chives and tarragon, pinch of cayenne pepper, Maldon sea salt and cracked pepper
4 long bamboo sandwich skewers',
'Step 1: Bacon Rendering & Crisp Texture - Arrange thick-cut Applewood smoked bacon strips in a cold 12-inch cast-iron skillet. Place over medium heat to slowly render the pork fat. Cook for 5 minutes, turn over, and cook for another 3-4 minutes until deeply bronzed, brittle-crisp, and wavy. Drain on paper towels; reserve 1 tsp bacon fat for bread browning.
Step 2: Meyer Lemon Herb Aioli - In a glass ramekin, whisk together whole-egg mayonnaise, grated garlic clove, Dijon mustard, fresh lemon juice, finely minced chives, fresh tarragon, cayenne pepper, sea salt, and black pepper. Cover and chill in the refrigerator for 10 minutes to allow the allium and herbal flavors to fuse.
Step 3: Triple Bread Searing - Brush both sides of the 3 Pullman bread slices very lightly with the reserved bacon fat. Toast in a wide toaster or on a hot flat griddle over medium heat until evenly golden amber on both surfaces with a gentle toasted crunch while keeping the crumb interior soft and pillowy.
Step 4: Tomato Curing - Lay the thick beefsteak tomato slices on a paper towel. Season both sides lightly with Maldon sea salt and freshly cracked black pepper; allow to sit for 3 minutes to draw out surface liquid so the bread stays crisp.
Step 5: Base Tier Construction - Place the bottom toast slice on a clean wooden cutting board. Slather with 1.5 tablespoons of herb aioli. Layer on crisp lettuce leaves, the seasoned tomato slices, and 2 strips of crispy bacon snapped in half to fit the boundaries neatly.
Step 6: Center Tier Assembly - Spread a light layer of aioli on both sides of the second toast slice; position it directly on top of the first bacon tier. Mound the shaved roasted turkey breast generously over the center, ensuring the meat is loosely folded to create height and airy texture rather than a dense slab. Top with the remaining 2 strips of crispy bacon.
Step 7: Cap & Structural Compression - Coat the underside of the third toast slice with herb aioli and place it atop the sandwich. Lay the palm of your hand flat over the top and press down firmly with gentle, even pressure to marry the tiers and settle the ingredients together.
Step 8: Precision Diagonal Quadrant Carving - Pierce the sandwich with 4 bamboo skewers, positioning one skewer midway along each of the four triangular zones. Using a razor-sharp serrated bread knife, slice diagonally from corner to corner in an ''X'' pattern using long sawing motions without squishing the bread. Stand the four club triangles upright, crust outward, accompanied by kettle-cooked potato crisps and cornichons.',
'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?auto=format&fit=crop&w=1000&q=80'),

(21, 17, 'Velvety Roasted Tomato Basil Bisque with Aged Cheddar Grilled Cheese', 'Lunch', 'United States (Classic Bistro Comfort)', 35,
'1.2 kg ripe Roma plum tomatoes (halved lengthwise)
1 whole head garlic (top 1/3 sliced off to expose cloves)
1 large sweet yellow onion (cut into 1-inch wedges)
3 tbsp cold-pressed extra virgin olive oil
1 tbsp aged Modena balsamic vinegar
2.5 cups rich simmered chicken bone broth or dark vegetable stock
1/2 cup heavy whipping cream (36% butterfat)
1 packed cup fresh sweet Genovese basil leaves
1 tbsp dark brown sugar
1 tsp smoked paprika
Coarse sea salt and cracked tellicherry peppercorns
For Grilled Cheese Dippers: 4 thick slices naturally leavened sourdough bread, 3 oz sharp aged white Vermont Cheddar, 2 oz cave-aged Gruyère, 3 tbsp softened European cultured butter',
'Step 1: High-Heat Roasting Preparation - Preheat convection oven to 415°F (212°C). Line a heavy rimmed half-sheet pan with parchment paper. Arrange halved plum tomatoes cut-side up across the pan alongside sweet onion wedges. Place the whole garlic head on a small foil sheet, drizzle with olive oil, wrap snugly, and place on the tray.
Step 2: Caramelizing the Alliums & Lycopene - Drizzle tomatoes and onions with 2 tablespoons olive oil and balsamic vinegar. Season generously with sea salt, cracked black pepper, and smoked paprika. Roast on the top oven rack for 32 to 35 minutes until the tomato skins blister and char at the edges, collapsing into concentrated sweet sugars, and the onions caramelize deeply.
Step 3: Aromatics Squeeze & Pot Deglaze - Heat 1 tablespoon olive oil in a heavy 6-quart enameled Dutch oven over medium heat. Squeeze the soft, caramelized, golden garlic cloves directly from their papery skins into the pot. Add the roasted tomatoes, charred onions, and all sticky roasted juices from the sheet pan. Use a wooden flat-edge spatula to scrape up every bit of concentrated fond.
Step 4: Broth Infusion & Herb Simmer - Pour in the simmering chicken bone broth, dark brown sugar, and half of the fresh basil leaves. Bring to a rolling boil over medium-high heat, then lower the flame and simmer gently uncovered for 12 minutes to allow the acids and aromatics to fuse seamlessly.
Step 5: High-Shear Emulsification - Remove the Dutch oven from the heat source. Using an immersion blender on high speed (or transferring in careful batches to a high-powered blender), purée the mixture for 2 full minutes until velvety, silky smooth, and uniform with no tomato skin flakes remaining.
Step 6: Finishing with Cream Royale - Return the pot to low heat. Slowly stir in the heavy whipping cream. Tear the remaining fresh basil leaves by hand into the soup. Taste and adjust seasoning with sea salt and cracked black pepper. Keep warm on the lowest flame without boiling.
Step 7: Sourdough Butter Searing - Butter the outer faces of the sourdough slices generously with softened European cultured butter. Layer grated sharp white cheddar and Gruyère evenly between the unbuttered sides. Toast in a medium-hot cast-iron skillet for 3.5 minutes per side until the bread develops a deep, golden-brown crunchy lace crust and the cheese is molten and stretchy.
Step 8: Velvety Ladle & Soldier Service - Ladle the steaming tomato bisque into wide, shallow ceramic bowls. Draw a swirl of heavy cream over the surface with a spoon tip and drop a fresh basil crown in the center. Slice the grilled cheese into rectangular ''soldiers'' and arrange alongside for dunking.',
'https://images.unsplash.com/photo-1547592166-23ac45744acd?auto=format&fit=crop&w=1000&q=80'),

(22, 3, 'Authentic Southern Sri Lankan Fish Ambul Thiyal (Sour Fish Curry)', 'Lunch', 'Sri Lanka (Southern Coast, Ambalangoda & Galle)', 40,
'750g fresh yellowfin tuna or sailfish (kelawalla or thalapath, cut into firm 1.5-inch cubes)
8-10 pieces dried Goraka (Garcinia cambogia, approx. 60g)
3 tbsp whole black peppercorns (Ceylon black pepper, freshly roasted and finely ground)
1 tsp ground roasted chili powder
1/2 tsp ground turmeric
1 tsp coarse sea salt
1 stem fresh curry leaves & 2-inch rampe (pandan leaf)
4 cloves garlic & 1-inch fresh ginger (crushed into paste)
1/2 cup warm water
Fresh banana leaf (cut to fit the bottom of the clay pot)',
'Step 1: Softening the Goraka Pods - Place the dried black goraka pieces into a small heatproof bowl. Pour 1/2 cup of boiling water over the pieces and let soak for 20 minutes until the leathery flesh softens, swells, and becomes pliable.
Step 2: Creating the Jet-Black Spice Paste - In a stone mortar (miris gala) or small high-speed spice grinder, process the softened goraka along with its soaking liquid, whole black peppercorns, roasted chili powder, turmeric, ginger-garlic paste, and coarse sea salt into an intensely dark, glossy, fragrant, jet-black paste with no gritty lumps.
Step 3: Fish Cubing & Inoculation - Cut fresh yellowfin tuna into clean 1.5-inch uniform cubes. Place the tuna cubes in a bowl, pour the black goraka-pepper paste over the fish, and delicately toss by hand until every single face of every cube is fully enveloped in the rich sour black paste. Let sit for 15 minutes.
Step 4: Clay Pot Lining & Banana Leaf Conditioning - Take a seasoned clay pot (wali athiliya). Pass a circular piece of banana leaf briefly over an open flame to soften and release its aromatic oils. Line the bottom of the pot with the conditioned leaf; this prevents sticking and imparts an earthy herbal aroma during cooking.
Step 5: Single-Layer Precision Tiling - Arrange the coated fish cubes in a tight, single layer on top of the banana leaf. Tuck fresh curry leaves and the bruised pandan leaf into the crevices between the fish pieces. Pour in 1/4 cup of water around the inner edges of the pot to provide steam.
Step 6: Covered Gentle Simmer - Cover the clay pot with its terracotta lid. Place over medium-low heat for 12 minutes. The fish will release its own intrinsic juices, which combine with the goraka paste into a bubbling, pungent black liquor.
Step 7: Slow Evaporation & Thickening - Remove the lid. Lower the flame to the lowest setting. Cook uncovered for another 15 to 18 minutes, shaking the pot gently by its handles every few minutes (never stir with a spoon, which would break the tender fish cubes). Continue cooking until all liquid evaporates, leaving the cubes coated in a thick, matte-black, tart glaze.
Step 8: Curing & Village Service - Extinguish the heat. Ambul Thiyal is famous for its natural preservation properties; it improves dramatically after resting 1 to 2 days as the tart organic hydroxycitric acids penetrate deep to the bone. Serve warm or room temperature alongside red kekulu rice and creamy coconut milk dhal.',
'assets/images/recipes/sri-lankan-fish-ambul-thiyal.jpg'),

(23, 9, 'Wok-Tossed Yangzhou Style Chicken & Egg Fried Rice', 'Lunch', 'China (Yangzhou, Jiangsu Province)', 20,
'4 cups cooked long-grain Jasmine rice (refrigerated overnight, individual grains separated)
200g chicken breast (diced into neat 1/4-inch cubes)
3 large farm eggs (lightly whisked with 1/2 tsp toasted sesame oil)
1/2 cup sweet garden peas & 1/2 cup finely brunoised carrots (blanched 60 seconds)
3 scallions (spring onions, white and green parts separated and finely sliced)
2 cloves garlic (finely minced)
2.5 tbsp peanut oil or high-smoke lard
1.5 tbsp premium light soy sauce
1 tsp Shaoxing rice wine
1/2 tsp ground white pepper
1/2 tsp fine sea salt',
'Step 1: Starchy Grain Separation - Take the day-old refrigerated jasmine rice and transfer to a large bowl. Using clean fingers lightly dampened with oil, break apart any clumps so that every single rice grain is individual, dry, and chilled. Moisture in fresh rice creates soggy mush; chilled dry rice guarantees the legendary springy bounce.
Step 2: Velvet Marination of Chicken - In a small bowl, toss the cubed chicken with 1 teaspoon light soy sauce, 1 teaspoon Shaoxing wine, 1/2 teaspoon cornstarch, and a pinch of white pepper. Let marinate for 10 minutes to protect the delicate poultry proteins during high-heat wok frying.
Step 3: Seasoning the Carbon Steel Wok - Place a heavy 14-inch round-bottom carbon-steel wok over the highest gas flame until wisps of white smoke rise from the patina. Swirl 1 tablespoon peanut oil around the circumference of the wok (''long yao'' technique) to create a non-stick cooking film.
Step 4: Flash-Cooking the Poultry - Add the marinated chicken cubes to the smoking wok. Stir-fry rapidly with a wok spatula for 90 seconds until the exterior is seared and opaque. Transfer chicken immediately to a warm side plate.
Step 5: Golden Egg Silk Ribbon Execution - Swirl another tablespoon of oil into the wok. Pour in the beaten egg mixture. It will instantly puff and blister vigorously. Immediately swirl the wok and break the soft curds with the spatula for 15 seconds, leaving the egg tender and semi-liquid.
Step 6: Rice Introduction & High-Wok Toss - Dump the cold separated rice directly on top of the soft eggs. Using the curved back of the wok spatula, press down on any remaining clusters, then toss vigorously from the wrist over maximum heat for 3 to 4 minutes. The rice grains must jump and dance in the pan as they absorb the fragrant egg coating and develop the smoky Maillard ''wok hei'' (breath of the wok).
Step 7: Vegetable & Aromatics Incorporation - Return the cooked chicken to the wok along with blanched peas, diced carrots, minced garlic, and the sliced scallion whites. Drizzle 1.5 tablespoons light soy sauce around the searing hot metal perimeter of the wok so it caramelizes instantly before touching the grains.
Step 8: Final Aromatics & Cantonese Plating - Season with fine sea salt, ground white pepper, and toasted sesame oil. Toss continuously for 60 seconds. Scatter the vibrant green scallion greens and give two final tossing flips. Plate immediately in a rounded ceramic bowl.',
'https://images.unsplash.com/photo-1603133872878-684f208fb84b?auto=format&fit=crop&w=1000&q=80'),

(24, 1, 'Traditional British Beer-Battered Fish and Chips with Tartar Sauce', 'Lunch', 'United Kingdom (England - Yorkshire Coast)', 30,
'2 large fresh fillets Atlantic cod or haddock (approx. 220g each, skinless and boneless)
4 large Maris Piper or Russet potatoes (peeled and cut into thick 3/4-inch chips)
Beef dripping or groundnut oil for deep frying
For Crisp Beer Batter: 1.5 cups all-purpose flour, 1/2 cup cornstarch, 1 tsp baking powder, 1/2 tsp sea salt, 1.25 cups ice-cold traditional English ale or lager (chilled until nearly freezing), 2 tbsp rice flour for dredging
For Homemade Tartar Sauce: 1/2 cup whole-egg mayonnaise, 2 tbsp finely chopped cornichons/capers, 1 tbsp fresh dill, 1 tbsp lemon juice, sea salt and black pepper
Malt vinegar & lemon wedges for serving',
'Step 1: Triple-Cooked Chip Preparation - Cut peeled Maris Piper potatoes into uniform 3/4-inch thick batons. Rinse under cold running water for 3 minutes to wash away surface starch. Place in a saucepan of salted cold water, bring to a boil, and simmer for 6-8 minutes until tender on the outside but still intact. Carefully drain and spread onto wire racks to steam-dry and cool completely.
Step 2: Blanching the Chips - Heat beef dripping or groundnut oil in a deep fryer or heavy Dutch oven to 265°F (130°C). Deep-fry the par-boiled chips in batches for 5 minutes without letting them color. Lift out with a spider skimmer, spread on wire racks, and let cool for 20 minutes (or refrigerate).
Step 3: Whipping the Sparkling Ale Batter - In a large bowl, whisk together all-purpose flour, cornstarch, baking powder, and sea salt. Right before frying, pour in the ice-cold bitter ale. Whisk gently with a fork just until combined; small lumps should remain. Keep cold. The carbon dioxide bubbles and ice-cold temperature will react violently with hot oil to create a light, honeycomb-crisp batter.
Step 4: Dredging & Dipping the Fish - Pat cod fillets completely dry with paper towels. Lightly dust with rice flour, shaking off all excess. Dip one fillet into the cold batter, ensuring total coverage, then lift and let excess batter drip off for 3 seconds.
Step 5: The ''Tail Wave'' Frying Technique - Heat frying oil to 365°F (185°C). Hold the cod fillet by its thin tail end and lower the thick end into the hot oil. Wave it back and forth gently for 4 seconds to seal the exterior batter before releasing it completely; this prevents the fish from sinking and sticking to the fryer basket bottom. Fry for 5 to 6 minutes, turning once, until deeply golden, blistered, and audibly crisp.
Step 6: Second Flash-Frying of Chips - Increase oil temperature to 375°F (190°C). Plunge the blanched chips back into the sizzling oil for 2.5 to 3 minutes until shatteringly crisp on the exterior with a fluffy, steaming potato core. Drain on paper towels and toss immediately with flaky sea salt.
Step 7: Emulsifying the Tartar Sauce - Stir together whole-egg mayonnaise, chopped brined capers, minced cornichons, fresh dill, lemon juice, and black pepper in a ramekin.
Step 8: Classical Paper Plating - Arrange the golden beer-battered cod alongside a generous mound of steaming hot chips. Serve immediately with a ramekin of homemade tartar sauce, a wedge of fresh lemon, and a bottle of English malt vinegar.',
'https://images.unsplash.com/photo-1579208030886-b937da0925dc?auto=format&fit=crop&w=1000&q=80'),

(25, 8, 'Authentic Mexican Carne Asada Street Tacos with Pico de Gallo & Salsa Verde', 'Lunch', 'Mexico (Michoacán & Mexico City)', 25,
'650g fresh skirt steak (arrachera) or flank steak
12 small fresh corn tortillas (taquería size)
For Citrus Marinade: 3 tbsp orange juice, 2 tbsp lime juice, 3 cloves garlic (minced), 1/2 cup fresh cilantro, 1 tbsp olive oil, 1 tsp ground cumin, 1 tsp Mexican oregano, 1 tsp chili powder, 1.5 tsp coarse sea salt
For Pico de Gallo: 2 ripe Roma tomatoes (diced), 1/2 white onion (finely chopped), 1 fresh jalapeño (seeded and minced), 1/4 cup chopped cilantro, 1 tbsp lime juice, salt
For Garnish: Fresh lime wedges, sliced radishes, grilled scallions (cebollitas)',
'Step 1: Citrus Enzymatic Marination - In a shallow glass dish, whisk fresh orange juice, lime juice, olive oil, minced garlic, chopped cilantro, cumin, Mexican oregano, chili powder, and sea salt. Lay the skirt steak into the marinade, turning to coat. Allow the meat to marinate for 25 minutes at room temperature; the citrus enzymes will break down surface connective tissue while infusing deep Latin brightness.
Step 2: Stone-Ground Pico de Gallo - In a non-reactive bowl, toss diced Roma tomatoes, finely chopped white onions, minced jalapeño pepper, fresh cilantro, lime juice, and a healthy pinch of coarse salt. Allow to sit for 15 minutes so the juices mingle into a vibrant relish.
Step 3: Cast-Iron Screaming Sear - Preheat a heavy cast-iron ribbed skillet or outdoor charcoal grill until smoking hot (over 500°F / 260°C). Remove steak from marinade and pat dry with paper towels (moisture impedes the Maillard crust).
Step 4: Flank Steak Grilling - Lay the steak onto the searing grill. Cook undisturbed for 3.5 minutes on the first side to achieve a deeply charred, smoky crust. Flip and cook for 2.5 to 3 minutes on the reverse side for a juicy medium-rare interior (internal temperature 130°F / 54°C).
Step 5: Grain Alignment Resting - Transfer the grilled steak to a warm wooden carving board. Tent loosely with aluminum foil and let rest for exactly 7 minutes. Resting allows the expanded cellular juices to redistribute back through the beef fibers.
Step 6: Knife Technique Against the Grain - Examine the muscle grain direction of the skirt steak. Using a sharp chef''s knife held at a 45-degree angle, slice the steak across the grain into thin 1/4-inch ribbons, then cross-chop into succulent bite-sized cubes.
Step 7: Double-Tortilla Taquería Warming - Brush a hot dry cast-iron comal or skillet with droplets of steak pan juices. Warm the corn tortillas for 20 seconds per side until soft, pliable, blistered, and steaming. Double up the tortillas for each taco in the traditional Mexican taquería street style.
Step 8: Street Assembly & Garnish - Heap a generous scoop of sizzling chopped carne asada into the center of each doubled tortilla. Crown with fresh pico de gallo, chopped raw white onion, fresh cilantro leaves, and a squeeze of lime juice. Serve with crispy sliced radishes and charred scallions.',
'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?auto=format&fit=crop&w=1000&q=80'),

(26, 14, 'Authentic Dutch Burgher Lamprais with Seeni Sambol, Frikkadels & Brinjal Moju', 'Lunch', 'Sri Lanka (Dutch Burgher Heritage, Colombo)', 60,
'2 cups short-grain Samba rice (cooked in rich meat bone stock with cardamom, cloves, and cinnamon)
For Three-Meat Curry: 400g mixed beef, chicken, and mutton/pork (simmered in roasted Sri Lankan spices and coconut milk)
For Frikkadels (Meatballs): 200g minced beef, 1 slice stale bread soaked in milk, 1 egg yolk, grated nutmeg, cloves, salt, rolled into small balls and deep-fried golden
For Brinjal Moju: 1 large eggplant (cut into thin batons, deep-fried until dark brown, and tossed in caramelized mustard-shallot-vinegar syrup)
For Seeni Sambol: 3 large onions (slowly caramelized with chili, tamarind, sugar, and cinnamon)
1/2 cup blanched Ash Plantain curry
Fresh green banana leaves (wilted over open fire for wrapping)',
'Step 1: Samba Rice Cooked in Meat Stock - Rinse short-grain samba rice thoroughly. In a heavy pot, toast the raw rice grains in ghee with bruised green cardamoms, cloves, and cinnamon. Pour in rich, gelatinous slow-simmered beef or bone stock. Cook until the rice absorbs the stock completely and each grain is plump, aromatic, and buttery.
Step 2: Slow-Braised Mixed Meat Curry - In an earthenware pot, simmer diced beef, mutton, and chicken pieces with roasted Sri Lankan spices, lemongrass, pandan, ginger, garlic, and coconut milk until the meats are meltingly tender and enveloped in a concentrated, thick, dark-brown gravy.
Step 3: Hand-Rolling Crispy Frikkadels - In a bowl, combine finely minced beef with egg yolk, soaked stale bread crumb, ground cloves, fresh grated nutmeg, salt, and pepper. Roll into bite-sized spherical meatballs (approx. 2cm diameter). Deep fry in hot coconut oil until deeply browned, crispy on the shell, and juicy inside.
Step 4: Preparing Brinjal Moju - Cut fresh purple eggplant into thin batons. Deep-fry in hot oil until shriveled, dark brown, and crisp. In a saucepan, simmer ground yellow mustard seeds, green chilies, red shallots, coconut vinegar, and sugar until a sticky glaze forms. Toss the fried eggplant into the glaze until completely soaked and glossy.
Step 5: Conditioning the Banana Leaves - Take fresh green plantain or banana leaves. Pass each sheet steadily over an open gas flame for 3 seconds per side; the heat activates natural waxy oils, transforming the brittle leaf into a supple, fragrant, leather-like wrapping material that will not crack.
Step 6: Architectural Parcel Assembly - Lay two conditioned banana leaves overlapping in a cross pattern on a clean workspace. Place a generous mound of warm aromatic samba rice in the dead center. Arrange one ladle of mixed meat curry on the rice, two crispy frikkadels, a spoonful of sweet-tangy brinjal moju, a portion of spicy caramelized seeni sambol, and a spoonful of ash plantain curry.
Step 7: Folding & Toothpick Locking - Fold the top and bottom of the banana leaf snugly over the filling, then fold in both sides tightly to create a neat, compact, rectangular envelope package. Secure the seams firmly with a toothpick or cotton kitchen twine.
Step 8: Oven Baking & Aroma Infusion - Preheat oven to 350°F (175°C). Place the wrapped lamprais parcels on a baking sheet and bake for 20 to 25 minutes. During this crucial baking phase, the intense steam inside the sealed parcel vaporizes the natural banana leaf oils, infusing every single grain of rice and curry with the unforgettable, quintessential Dutch Burgher aroma. Serve unopened at the table for guests to unwrap.',
'assets/images/recipes/sri-lankan-lamprais.jpg'),

(27, 11, 'Classic Italian Panini Caprese with Buffalo Mozzarella, Pesto & Heirloom Tomatoes', 'Lunch', 'Italy (Capri, Campania)', 15,
'2 artisanal Ciabatta or focaccia rolls (split horizontally)
250g fresh Mozzarella di Bufala Campana (drained and sliced 1/3-inch thick)
2 large ripe heirloom beefsteak tomatoes (Cherokee Purple or Brandywine, sliced)
For Fresh Ligurian Pesto: 2 cups fresh Genovese basil leaves, 2 tbsp toasted pine nuts, 1 clove garlic, 1/3 cup Parmigiano-Reggiano, 1/2 cup cold-pressed extra virgin olive oil, sea salt
1 tbsp aged Aceto Balsamico Tradizionale di Modena (dense and syrupy)
Flaky sea salt (Maldon) and freshly cracked black pepper',
'Step 1: Stone-Ground Pesto Emulsion - In a chilled marble mortar or small food processor, blend fresh Genovese basil leaves, toasted Mediterranean pine nuts, a pinch of coarse sea salt, and half a garlic clove until a bright green paste forms. Slowly drizzle in cold-pressed extra virgin olive oil while pulsing, then gently fold in microplaned Parmigiano-Reggiano. Keep chilled to maintain emerald green hue.
Step 2: Draining Fresh Buffalo Mozzarella - Slices of high-moisture Mozzarella di Bufala can make artisanal bread soggy. Slice the mozzarella into 1/3-inch rounds and lay them across clean lint-free linen towels or layered paper towels for 8 minutes to wick away excess whey liquid.
Step 3: Heirloom Tomato Seasoning - Slice ripe heirloom tomatoes into thick rounds. Lay on a wooden board and season with flaky Maldon sea salt and cracked Tellicherry black pepper; allow to sit for 3 minutes to awaken the natural sugars and lycopene.
Step 4: Ciabatta Preparation - Halve the artisanal ciabatta rolls horizontally. Lightly brush the cut sides with extra virgin olive oil.
Step 5: Panini Assembly - Spread a generous layer of freshly pounded basil pesto across both cut sides of the ciabatta. Layer the seasoned heirloom tomato slices across the bottom half, followed by overlapping rounds of drained buffalo mozzarella.
Step 6: Modena Balsamic Drizzle - Drizzle the mozzarella rounds with drops of aged thick balsamic vinegar and tuck 3-4 fresh whole sweet basil leaves directly between the cheese layers.
Step 7: Cast-Iron Panini Pressing - Heat a heavy ridged cast-iron grill pan over medium heat. Place the assembled panini onto the pan. Place a second heavy cast-iron skillet (or foil-wrapped brick) on top of the sandwich to apply uniform downward pressure. Press for 3 to 4 minutes until the ciabatta exterior is golden-brown, crispy, and scored with deep grill marks, while the interior buffalo mozzarella softens into a warm, creamy consistency.
Step 8: Diagonal Carving & Service - Remove from the grill pan, slice cleanly on a diagonal bias with a sharp bread knife, and serve immediately with a side of Castelvetrano olives.',
'https://images.unsplash.com/photo-1528736235302-52922df5c122?auto=format&fit=crop&w=1000&q=80'),

(28, 28, 'Authentic Vietnamese Lemongrass Chicken Banh Mi (Bánh Mì Gà Nướng)', 'Lunch', 'Vietnam (Saigon / Ho Chi Minh City)', 25,
'2 authentic Vietnamese baguettes (light, ultra-crisp paper-thin crust, airy hollow crumb)
400g boneless skinless chicken thighs (sliced into thin fillets)
For Lemongrass Marinade: 2 stalks fresh lemongrass (white tender core only, finely minced), 2 cloves garlic (minced), 1 shallot (minced), 1.5 tbsp fish sauce (nước mắm nhi), 1 tbsp sweet dark soy sauce, 1 tbsp brown sugar, 1 tsp sesame oil, 1/2 tsp black pepper
For Quick Pickled Đồ Chua: 1 medium carrot and 1 small daikon radish (julienned into thin matchsticks), 1/2 cup rice vinegar, 1/2 cup warm water, 2 tbsp sugar, 1/2 tsp salt
For Sandwich Assembly: 2 tbsp French-style egg yolk mayonnaise (bơ), 1 tsp Maggi liquid seasoning, 1 Persian cucumber (thinly sliced lengthwise), 1 fresh jalapeño or bird''s eye chili (thinly sliced), 1 bunch fresh cilantro sprigs',
'Step 1: Quick Pickling the Đồ Chua - In a glass jar, dissolve sugar and salt into warm water and rice vinegar. Pack the julienned carrots and daikon radishes into the brine. Let pickle at room temperature for at least 20 minutes (the vegetables will become flexible, sweet, acidic, and crunchy). Drain thoroughly before assembly.
Step 2: Pounding the Lemongrass Marinade - Using a heavy mortar and pestle, pound the minced lemongrass core, garlic, and shallot into a moist aromatic pulp. Whisk in premium fish sauce, sweet dark soy sauce, brown sugar, sesame oil, and black pepper.
Step 3: Poultry Inoculation - Coat the chicken thigh fillets in the lemongrass paste. Allow to marinate for 20 minutes so the alliums and citrusy herb notes penetrate deep into the meat proteins.
Step 4: Charcoal Griddle Searing - Heat a cast-iron grill pan or outdoor charcoal grill over medium-high heat. Lay the chicken thighs onto the grill. Sear for 4 minutes on the first side until deep caramelized char spots develop from the sugar and fish sauce. Flip and cook for another 3-4 minutes until cooked through and smoky. Transfer to a cutting board and slice into 1/2-inch strips.
Step 5: Conditioning the Baguette - Preheat oven to 400°F (200°C). Spritz the exterior of the Vietnamese baguettes with a fine mist of water. Bake for 3 minutes until the crust becomes shatteringly crisp like eggshells while the inside remains soft and steamy.
Step 6: Slicing & Condiment Foundation - Slit the warm baguette lengthwise down one side, leaving the back hinge intact. Generously smear rich Vietnamese egg mayonnaise across both inner walls. Splash 3-4 drops of savory Maggi liquid seasoning along the length of the bread.
Step 7: Architectural Layering - Place long ribbons of crisp cucumber along the base. Pack the warm, fragrant grilled lemongrass chicken slices tightly along the baguette. Top with a generous mound of drained pickled carrot and daikon (đồ chua).
Step 8: Fresh Herb Crown & Street Presentation - Tuck fresh jalapeño pepper rounds and abundant sprigs of fresh cilantro leaves into the top seam. Press the sandwich closed gently; you should hear the crust crackle. Serve immediately wrapped in parchment paper.',
'https://images.unsplash.com/photo-1626804475297-41608ea09aeb?auto=format&fit=crop&w=1000&q=80'),

(29, 16, 'Creamy Garlic Butter Gulf Shrimp Fettuccine Alfredo', 'Lunch', 'Italy (Rome, Lazio) / Italian-American Bistro', 20,
'350g fresh egg fettuccine pasta (or high-quality bronze-die extruded dried fettuccine)
400g large wild Gulf shrimp (peeled, deveined, tails on, patted dry)
4 tbsp European cultured unsalted butter (82% fat)
4 cloves fresh garlic (thinly shaved into translucent chips)
1 cup heavy whipping cream (strictly 36% butterfat)
1.25 cups freshly grated Parmigiano-Reggiano (aged 24 months, finely microplaned)
1/4 tsp freshly grated whole nutmeg
2 tbsp finely chopped fresh flat-leaf Italian parsley
Coarse sea salt and freshly cracked white & black pepper',
'Step 1: Starchy Pasta Water Setup - Bring a large 6-quart pasta pot filled with 4 quarts of filtered water to a roaring boil. Add 2 tablespoons coarse sea salt (the water should taste like the Mediterranean sea). Cooking pasta in abundant salted water ensures the strands cook evenly without clumping.
Step 2: Shrimp Sear & Fond Creation - Season peeled shrimp lightly with sea salt and black pepper. In a wide 12-inch heavy stainless-steel skillet or sauté pan, melt 1 tablespoon butter over medium-high heat. Add the shrimp in a single layer. Sear undisturbed for 90 seconds until the underside turns coral-pink and lightly caramelized. Flip and cook for 60 seconds more until just cooked through. Immediately transfer shrimp to a warm plate; do not overcook.
Step 3: Cooking the Fresh Fettuccine - Drop the fresh fettuccine into the boiling water. Cook for 2.5 to 3 minutes (or 8-9 minutes if using dried) until strictly ''al dente'' (firm to the tooth with a tiny white core). Reserve 1 cup of cloudy, starch-rich pasta water before draining.
Step 4: Garlic Sauté & Cream Reduction - In the same skillet used for the shrimp, lower heat to medium and add remaining 3 tablespoons butter. Add the shaved garlic chips and sauté gently for 60 seconds until fragrant and golden without browning. Pour in the heavy whipping cream. Bring to a gentle simmer for 3 minutes, allowing the cream to reduce slightly into a silky coating.
Step 5: Cheese Emulsion Technique - Remove the skillet from the direct flame (excessive heat will cause the dairy proteins to separate into oily graininess). Gradually add the microplaned Parmigiano-Reggiano in 3 batches, whisking vigorously after each addition until completely melted, smooth, and emulsified into a luxurious, glossy sauce.
Step 6: Pasta & Starch Water Union - Add the drained al dente fettuccine directly into the skillet with the Alfredo sauce. Splash in 1/4 cup of the reserved hot pasta water. Toss and swirl the pasta continuously with culinary tongs over low heat for 90 seconds. The hot cooking water and cheese fats bind into a creamy, cohesive sauce that clings tightly to every noodle strand (nappe consistency).
Step 7: Finishing Spices & Seafood Reintegration - Grate fresh nutmeg over the pasta and season with cracked white pepper. Return the seared shrimp and all resting pan juices into the pan, tossing gently to coat in the velvety sauce.
Step 8: Plating & Garnish - Twirl the fettuccine into tall nests in warmed wide pasta bowls using carving tongs and a ladle. Arrange the glistening pink shrimp over the top, sprinkle with chopped flat-leaf parsley, and serve immediately with extra microplaned parmesan.',
'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=1000&q=80'),

(30, 27, 'Traditional Korean Beef Bulgogi Bowl with Steamed Rice & Kimchi', 'Lunch', 'South Korea (Seoul)', 25,
'500g USDA Choice beef ribeye or top sirloin (sliced paper-thin across the grain)
For Authentic Pear Marinade: 1/2 Korean Asian pear (bae, peeled and grated), 1/2 small onion (grated), 4 cloves garlic (minced), 1 tsp fresh ginger (grated), 4 tbsp premium Korean soy sauce (yangjo ganjang), 2 tbsp brown sugar, 1 tbsp pure honey, 2 tbsp toasted sesame oil, 1 tbsp toasted sesame seeds, 1 tbsp mirin (rice wine), 1/4 tsp black pepper
1 small white onion (sliced)
2 scallions (cut into 2-inch batons)
1 small carrot (thinly sliced on a bias)
4 cups hot steamed Korean short-grain rice (ssalbap)
Aged napa cabbage kimchi, toasted sesame seeds, and perilla leaves for serving',
'Step 1: Paper-Thin Beef Slicing Technique - Place the beef ribeye in the freezer for 45 minutes until firm but not frozen solid. Using a sharp slicing knife, shave the beef across the grain into paper-thin, translucent ribbons (approx. 1/16-inch thick). Thin slicing ensures maximum surface absorption of marinade and instant high-heat cooking.
Step 2: Asian Pear Enzymatic Tenderization - Grate the peeled Asian pear and onion on the fine side of a box grater into a large bowl. Asian pear contains natural calpain and proteolytic enzymes that break down tough beef collagen without turning the meat to mush.
Step 3: Marinade Assembly & Inoculation - To the grated pear mixture, add minced garlic, grated ginger, Korean soy sauce, brown sugar, honey, toasted sesame oil, toasted sesame seeds, mirin, and cracked black pepper. Whisk until sugar is completely dissolved. Add the shaved ribeye ribbons, separating the strands with your fingers so every piece is coated. Marinate for 30 minutes at room temperature.
Step 4: Vegetable Prep - Slice yellow onions into crescents, slice carrots into thin matchsticks, and cut green scallions into 2-inch segments.
Step 5: High-Heat Skillet Searing - Heat a heavy cast-iron skillet or wok over the highest heat until smoking. Add 1 tablespoon neutral high-smoke oil. Working in two batches (never crowd the pan, which causes braising instead of searing), add half the marinated beef in an even layer.
Step 6: Caramelizing the Bulgogi - Cook undisturbed for 90 seconds over high heat so the sugars in the marinade caramelize into a smoky, dark char. Flip and toss with tongs for another 90 seconds. Add the sliced onions, carrots, and scallions; toss together for 60 seconds until the vegetables are tender-crisp.
Step 7: Glaze Reduction - Pour in any remaining marinade liquid from the bowl during the final 30 seconds of cooking. Let it bubble violently and reduce into a glossy, sweet-savory glaze clinging to the beef ribbons.
Step 8: Korean Bowl Plating - Scoop steaming hot Korean short-grain sticky rice into heavy ceramic bowls. Mound the sizzling, tender bulgogi beef and vegetables over half the bowl. Sprinkle liberally with toasted white sesame seeds and sliced scallions. Serve with aged sour napa cabbage kimchi and perilla leaves.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/c/ce/Bulgogi_2.jpg/960px-Bulgogi_2.jpg'),

(31, 26, 'Authentic Mediterranean Crispy Falafel Wrap with Creamy Tahini & Pickled Turnips', 'Lunch', 'Middle East (Levant - Lebanon & Palestine)', 30,
'2 cups dried chickpeas (garbanzo beans, strictly NOT canned, soaked in water for 24 hours)
1 small yellow onion (quartered)
4 cloves garlic (peeled)
1 large bunch fresh flat-leaf parsley (leaves and tender stems, approx. 1 cup)
1 large bunch fresh cilantro (approx. 1 cup)
1 tbsp ground cumin & 1 tbsp ground coriander
1/2 tsp cayenne pepper & 1/2 tsp ground cardamom
1.5 tsp fine sea salt & 1/2 tsp black pepper
1 tsp baking soda (added right before frying for airy interior)
2 tbsp toasted sesame seeds
High-smoke sunflower oil for deep frying
For Serving: Fresh Lebanese flatbread pita, creamy lemon-garlic tahini sauce, chopped tomatoes, cucumbers, and pink pickled turnips',
'Step 1: The 24-Hour Raw Chickpea Soak - Place dry chickpeas in a large bowl, cover with 4 inches of cold filtered water, and let soak for 20 to 24 hours until they expand to more than double their size. Drain thoroughly and pat completely dry on kitchen towels. Vital culinary law: never use cooked or canned chickpeas; cooked chickpeas turn to mush, whereas raw soaked chickpeas retain the essential starch matrix that holds falafels together without flour.
Step 2: Processing the Herb-Chickpea Mixture - Add the soaked raw chickpeas, quartered onion, garlic cloves, fresh flat-leaf parsley, and cilantro to a food processor. Pulse in 5-second bursts until the mixture resembles coarse cornmeal or wet sand. Do not purée into hummus; textural grit is essential.
Step 3: Spice Seasoning & Chilling - Transfer the pulsed mixture to a bowl. Fold in ground cumin, ground coriander, cardamom, cayenne pepper, fine sea salt, black pepper, and toasted sesame seeds. Cover with plastic wrap and chill in the refrigerator for 45 minutes; chilling firms the starches for effortless shaping.
Step 4: Leavening Activation - Remove mixture from the refrigerator. Sprinkle baking soda over the mixture and gently fold it in. The baking soda releases tiny carbon dioxide pockets upon hitting hot oil, ensuring the interior crumb remains light, fluffy, and tender rather than dense.
Step 5: Shaping with Falafel Mold - Using a traditional brass falafel scoop (aleb falafel) or two spoons, shape the mixture into 1.5-inch flattened discs. Do not press too tightly; compacting makes the falafels heavy.
Step 6: Deep Frying Temperature Management - Heat 3 inches of sunflower oil in a deep heavy pot to exactly 365°F (185°C). Gently lower 5 to 6 falafel discs into the hot oil. Fry for 3.5 to 4 minutes, turning occasionally, until the crust turns an even, deep mahogany-brown and shatteringly crisp.
Step 7: Skimming & Draining - Remove the fried falafels with a wire spider skimmer and transfer to a paper towel-lined tray. Immediately sprinkle with a touch of flaky sea salt. Break one open to verify: the shell should be crunchy, while the interior is steaming, vibrant herb-green, and fluffy.
Step 8: Lebanese Pita Wrap Assembly - Warm fresh Lebanese flatbread. Smear generously with creamy lemon-garlic tahini. Place 4 hot falafels down the center and gently crush them with the back of a fork. Top with diced Persian cucumbers, ripe tomatoes, fresh mint leaves, and vibrant pink pickled turnips. Roll up tightly into a wrap and serve.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/5/57/Falafels_2.jpg/960px-Falafels_2.jpg'),

(32, 24, 'Authentic Japanese Chicken Katsu Curry with Steamed Koshihikari Rice', 'Lunch', 'Japan (Tokyo, Yoshoku Cuisine)', 35,
'2 large boneless skinless chicken breasts (approx. 220g each, pounded to 1/2-inch thickness)
For Katsu Breading: 1/2 cup all-purpose flour, 2 large eggs (whisked with 1 tbsp water), 2 cups authentic Japanese coarse panko breadcrumbs, sea salt and freshly cracked black pepper
High-smoke peanut or canola oil for deep frying
For Rich Yoshoku Curry Sauce: 1 large yellow onion (finely grated/pureed), 1 medium carrot (cut into bite-sized rangiri chunks), 1 Yukon Gold potato (peeled and cubed), 3 tbsp unsalted butter, 3.5 tbsp all-purpose flour, 2 tbsp S&B Japanese curry powder, 1 tbsp garam masala, 3 cups rich chicken stock, 1 tbsp tonkatsu sauce, 1 tbsp soy sauce, 1 tbsp grated Fuji apple, 1 tsp honey
4 cups hot steamed Japanese short-grain rice (Koshihikari)
Fukujinzuke (red pickled vegetables) for garnish',
'Step 1: Caramelized Onion & Roux Foundation - In a heavy saucepan, melt 3 tablespoons unsalted butter over medium-low heat. Add the grated onion and cook down slowly for 12-15 minutes until caramelized into a sweet golden-brown purée. Sprinkle in the flour, Japanese curry powder, and garam masala. Cook the spice-flour roux for 3 minutes, stirring constantly until fragrant and toasted chocolate-brown in color.
Step 2: Broth Emulsion & Simmer - Gradually whisk the warm chicken stock into the roux, a splash at a time, to create a completely lump-free, velvety base. Add the carrot chunks, cubed potatoes, grated Fuji apple, soy sauce, tonkatsu sauce, and honey. Bring to a boil, then reduce heat to low, cover, and simmer for 20 minutes until vegetables are tender and sauce is glossy and thick.
Step 3: Poultry Pounding - Lay the chicken breasts between sheets of plastic wrap. Using the flat side of a meat mallet, gently pound the breasts to a uniform 1/2-inch thickness. Season both sides with fine sea salt and freshly cracked black pepper.
Step 4: Standard Japanese Breading Station - Arrange three shallow wide trays: Tray 1 with flour, Tray 2 with beaten egg wash, Tray 3 with airy Japanese panko breadcrumbs. Dredge the chicken in flour, shaking off all excess; dip completely into the egg wash; then press firmly into the panko breadcrumbs so the flakes adhere in a thick, even crust.
Step 5: Frying the Chicken Cutlet - Heat 2 inches of peanut oil in a deep skillet to 340°F (170°C). Gently slide the breaded cutlets into the oil. Fry for 4.5 minutes, turning once, until the panko turns a rich, uniform golden-amber color and the internal temperature reaches 165°F (74°C).
Step 6: Wire Rack Resting - Transfer the fried cutlet immediately to an elevated wire cooling rack. Let rest for 3 minutes; resting allows steam to escape outward without softening the crispy bottom crust.
Step 7: Slicing the Katsu - Place the rested cutlet on a cutting board. Using one decisive downward cut per motion with a sharp chef''s knife, slice the katsu crosswise into 3/4-inch strips. Listen for the audible crackle of the panko.
Step 8: Yoshoku Plate Presentation - Mold steaming hot Koshihikari rice onto one side of an oval ceramic curry dish. Lay the sliced crispy katsu cutlet overlapping across the center. Ladle the hot, rich, aromatic curry sauce generously around the opposite side of the plate, coating half of the cutlet. Garnish with ruby-red sweet fukujinzuke pickles.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/9/9f/Katsu-curry_002.jpg/960px-Katsu-curry_002.jpg'),

(33, 5, 'Classic American Cobb Salad with Roquefort Blue Cheese Vinaigrette', 'Lunch', 'United States (Hollywood, California - Brown Derby, 1937)', 20,
'1 head fresh iceberg lettuce & 1 head romaine lettuce (washed, spun dry, and finely shredded)
1 bunch fresh watercress (stems removed)
2 grilled boneless chicken breasts (chilled and diced into 1/2-inch cubes)
6 strips thick Applewood smoked bacon (cooked crisp and crumbled)
2 ripe Hass avocados (peeled and diced)
3 large hard-boiled farm eggs (peeled and chopped)
2 ripe vine tomatoes (seeded and neatly diced)
1/2 cup crumbled authentic French Roquefort or Maytag blue cheese
2 tbsp fresh chives (minced)
For Red Wine Vinaigrette: 1/4 cup red wine vinegar, 1 tbsp Dijon mustard, 1 clove garlic (minced), 2/3 cup extra virgin olive oil, 1 tsp Worcestershire sauce, sea salt and cracked pepper',
'Step 1: Greens Base Blend - In a large bowl, toss together the shredded iceberg lettuce, crisp romaine, and peppery watercress. Spread the greens across the bottom of a wide, shallow oval serving platter to form an even, cold, crisp verdant foundation.
Step 2: Bacon Rendering - Fry Applewood smoked bacon in a skillet until brittle and mahogany-brown. Drain thoroughly on paper towels and chop into bite-sized crispy nuggets.
Step 3: Egg Steaming & Dicing - Steam large farm eggs for exactly 11 minutes, plunge immediately into ice water to arrest cooking, peel, and dice into clean, vibrant yellow-and-white cubes.
Step 4: Whisking the Roquefort Vinaigrette - In a glass jar, combine red wine vinegar, minced garlic, Dijon mustard, Worcestershire sauce, salt, and black pepper. Slowly whisk in extra virgin olive oil until emulsified. Crumble in 2 tablespoons of the Roquefort cheese for creamy pungency.
Step 5: Precision Striping (The Hollywood Presentation) - Assemble the toppings in distinct, colorful, parallel rows across the bed of shredded greens: a row of diced grilled chicken, a row of crumbled crispy bacon, a row of diced ripe tomatoes, a row of diced hard-boiled eggs, a row of buttery diced avocados, and a row of crumbled blue cheese.
Step 6: Allium Garnish - Scatter finely minced fresh chives over the entire salad to tie the geometric color bands together.
Step 7: Table Service - Present the salad unmixed to showcase the iconic Brown Derby striped presentation.
Step 8: Final Toss - At the table, drizzle the chilled Roquefort red wine vinaigrette over the rows, and toss with salad servers just before serving onto chilled plates.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/3/38/Cobb_salad%2C_15_October_2010.jpg/960px-Cobb_salad%2C_15_October_2010.jpg'),

(34, 7, 'Authentic Sri Lankan Egg & Cheese Street Kottu Roti', 'Lunch', 'Sri Lanka (Colombo & Batticaloa Street Culture)', 25,
'5 pieces authentic Godamba Roti (Sri Lankan flatbread, thinly sliced into ribbons/noodles)
3 large farm eggs
1/2 cup shredded Happy Cow cheese or sharp mild cheddar
1 medium red onion (sliced)
2 green bird''s eye chilies (sliced into rounds)
1 cup finely shredded green cabbage & 1/2 cup julienned carrots
1 stem fresh curry leaves & 2-inch rampe (pandan leaf)
2 tbsp virgin coconut oil
1/2 cup spicy Sri Lankan chicken curry gravy (or vegetable curry gravy)
1 tsp roasted chili powder & 1/2 tsp crushed black pepper
Sea salt to taste
Lime wedges for serving',
'Step 1: Godamba Roti Shredding - Stack freshly made or store-bought Sri Lankan godamba roti flatbreads. Roll them tightly like a cigar, then slice crosswise with a heavy knife into 1/3-inch ribbons. Fluff the cut ribbons apart so they resemble thick noodles.
Step 2: Heavy Cast-Iron Griddle Conditioning - Heat a wide, heavy flat cast-iron griddle (or 14-inch heavy skillet) over high heat until sizzling hot. Add 2 tablespoons virgin coconut oil.
Step 3: Sautéing Alliums & Vegetables - Add the sliced red onions, green chilies, fresh curry leaves, and pandan leaf. Sauté vigorously for 2 minutes until aromatic. Toss in the shredded cabbage, julienned carrots, and leeks; stir-fry for 2 minutes until tender-crisp while retaining a smoky crunch.
Step 4: Scrambling Eggs on the Iron - Push the vegetables to the outer rim of the hot griddle, creating an empty circular well in the center. Crack in all 3 eggs. Let the whites set for 10 seconds, then scramble rapidly with heavy metal spatulas directly on the iron until curds form.
Step 5: Incorporating Roti Ribbons - Dump the sliced godamba roti ribbons directly onto the scrambled eggs and vegetables. Toss everything together vigorously over high heat.
Step 6: The Rhythmic Blade Churn & Gravy Splash - Pour the spicy hot chicken curry gravy directly over the roti. Add roasted chili powder, crushed black pepper, and sea salt. Using two heavy flat metal blades (or cleavers), chop and toss the roti with rhythmic, rapid downward strokes against the griddle, cutting the ribbons and vegetables into small, uniform, flavorful bits while evaporating excess liquid.
Step 7: Molten Cheese Incorporation - Scatter shredded cheese evenly across the steaming, smoking hot kottu. Give three final rapid blade chops and folds so the cheese melts instantly throughout the spicy roti ribbons, creating rich savory threads.
Step 8: Piping Hot Street Service - Transfer the steaming hot kottu immediately to a wide plate. Garnish with a fresh wedge of lime to squeeze over the rich cheese and curry before eating.',
'assets/images/recipes/sri-lankan-chicken-kottu.jpg'),

(35, 1, 'Pan-Seared USDA Prime Ribeye Steak with Garlic Herb Baste', 'Dinner', 'United States (American Steakhouse Tradition)', 25,
'1 USDA Prime boneless Ribeye steak (approx. 450g / 1.5 inches thick, richly marbled)
3 tbsp high-smoke avocado oil or clarified butter
3 tbsp European cultured unsalted butter (82% fat)
4 cloves fresh purple garlic (crushed lightly in skins)
3 sprigs fresh woody thyme & 2 sprigs fresh rosemary
Coarse sea salt (or Maldon flaky salt) & coarse freshly cracked Tellicherry black pepper',
'Step 1: Tempering & Surface Desiccation - Remove the prime ribeye from refrigeration exactly 45 minutes prior to cooking. Pat the steak aggressively dry on all sides using paper towels. Moisture on the meat surface prevents the temperature from climbing past the boiling point of water, impeding the crucial Maillard browning reaction.
Step 2: Aggressive Crust Seasoning - Just before placing in the pan, season the steak generously with coarse sea salt and cracked black pepper, pressing the seasoning firmly into the fat cap and meat fibers on all sides.
Step 3: Preheating Heavy Cast-Iron - Place a seasoned 12-inch cast-iron skillet over high heat for 5 minutes until dry and smoking hot. Add 2 tablespoons of high-smoke avocado oil, swirling to coat; wait until the oil shimmers with wisps of white smoke.
Step 4: Initial High-Heat Sear - Lay the ribeye gently away from you into the hot skillet to avoid oil splash. Sear undisturbed for 2.5 minutes to build a deep, mahogany-brown caramelized crust. Using stainless-steel tongs, lift the steak and sear the thick outer fat cap edge for 60 seconds to render the fat.
Step 5: The Flip & Temperature Control - Flip the steak onto the reverse side. Immediately reduce heat to medium-high. Sear for 2 minutes to establish the bottom crust.
Step 6: The Arrosé French Butter Baste - Drop 3 tablespoons of cold cultured butter, the crushed garlic cloves, thyme sprigs, and rosemary into the foaming oil next to the steak. Tilt the skillet slightly toward you. Using a large metal spoon, continuously scoop the foaming, aromatic butter and cascade it over the top of the steak in rapid succession for 90 seconds. The hot butter transfers heat evenly to the meat while infusing garlic and herbal aromatics.
Step 7: Thermometer Probe Precision - Insert an instant-read digital probe thermometer horizontally into the center of the steak. Pull the steak from the pan when internal temperature registers 125°F (52°C) for medium-rare, as carryover cooking will raise the temperature to 132°F (56°C).
Step 8: Resting Equilibrium & Presentation - Transfer the ribeye to a warm wooden carving board. Pour the pan garlic butter and herbs over the steak. Let rest undisturbed for 8 minutes; during rest, muscle fibers relax, reabsorbing the flavorful juices throughout the steak. Carve into thick slices and finish with crunchy Maldon salt flakes.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/a/af/Ribeye_steak%2C_hot_off_the_grill.jpg/960px-Ribeye_steak%2C_hot_off_the_grill.jpg'),

(36, 16, 'Authentic Roman Spaghetti alla Carbonara (Zero Cream)', 'Dinner', 'Italy (Rome, Lazio)', 20,
'400g bronze-die extruded Italian Spaghetti (such as Gragnano IGP)
200g artisanal Italian Guanciale (cured pork jowl, cut into 1/4-inch thick lardons)
4 large farm-fresh egg yolks + 1 whole egg (strictly room temperature)
1 cup freshly grated Pecorino Romano DOP (aged, sharp sheep''s milk cheese)
1/3 cup freshly grated Parmigiano-Reggiano DOP (for balance)
2 tbsp whole black peppercorns (toasted and coarsely cracked in a mortar)
Coarse sea salt for pasta water',
'Step 1: The Guanciale Rendering - Place the sliced guanciale strips into a cold, heavy-bottomed stainless steel or cast-iron skillet with no additional oil. Place over medium-low heat. Slowly render the fragrant pork fat for 8-10 minutes until the guanciale cubes become deeply golden and shatteringly crisp on the outside while remaining chewy inside. Remove the skillet from heat, transfer crispy lardons to a plate, and reserve the golden rendered fat in the pan.
Step 2: Toasting Whole Peppercorns - In a small dry skillet, toast whole black peppercorns over medium heat for 2 minutes until intensely aromatic. Transfer to a granite mortar and pound coarsely; freshly crushed pepper delivers floral pungency without harsh bitterness.
Step 3: Creating the ''Carbocream'' Emulsion - In a large ceramic or glass bowl, whisk the 4 egg yolks, 1 whole egg, grated Pecorino Romano DOP, and Parmigiano-Reggiano together until a thick, paste-like cream forms. Whisk in half of the cracked black pepper and 2 tablespoons of the warm (not boiling) rendered guanciale fat to temper the eggs.
Step 4: Boiling Pasta in Modest Water - Bring 3.5 quarts of water to a boil with 1 tablespoon coarse sea salt (less salt than usual, as Pecorino and Guanciale are naturally salty). Cook the spaghetti for 8 minutes, pulling it 2 minutes before the package al dente time.
Step 5: Marrying Pasta with Pork Essence - Using tongs, transfer the steaming spaghetti directly from the boiling water into the skillet with the rendered guanciale fat over medium heat. Add 1/2 cup of starchy boiling pasta water. Vigorously toss the pasta for 60 seconds so the starch and pork fat emulsify into a glistening base coat.
Step 6: Off-Heat Egg Incorporation - Crucial culinary milestone: remove the skillet completely from the stove and let it cool for 30 seconds (if the pan is too hot, the eggs will scramble). Dump the spaghetti and remaining pan juices directly into the ceramic bowl with the egg-cheese paste.
Step 7: High-Speed Mantecatura Swirl - Vigorously toss and stir the pasta with tongs. The residual heat of the hot noodles melts the Pecorino while gently pasteurizing the egg yolks, creating a rich, glossy, mirror-smooth yellow sauce without a single grain of cream.
Step 8: Final Plating & Roman Garnish - Twirl tall nests of spaghetti into warm ceramic pasta bowls. Top with the crispy guanciale lardons, extra grated Pecorino Romano DOP, and a generous crack of black pepper. Serve immediately.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/3/33/Espaguetis_carbonara.jpg/960px-Espaguetis_carbonara.jpg'),

(37, 7, 'Authentic Sri Lankan Black Pork Curry (Kalu Pol Mas Kari)', 'Dinner', 'Sri Lanka (Southern & Sabaragamuwa Provinces)', 55,
'800g pork belly and pork shoulder (cut into 1-inch curry cubes with balanced fat and lean)
For Kalu Pol (Black Spice Paste): 1/2 cup freshly grated coconut, 2 tbsp uncooked raw rice grains, 1 tbsp coriander seeds, 1.5 tsp cumin seeds, 1.5 tsp sweet fennel seeds, 1 sprig curry leaves
For Aromatics & Marinade: 5 cloves garlic & 1.5-inch ginger (pounded to paste), 2 tbsp dark roasted Sri Lankan curry powder, 1.5 tbsp roasted black chili powder, 1/2 tsp ground turmeric, 2 tbsp freshly ground black pepper
3-4 pieces dried Garcinia (Goraka, soaked in warm water and ground into smooth sour paste)
1 large red onion (sliced), 2 green chilies (slit), 2-inch rampe (pandan leaf), 1 quill Ceylon cinnamon
2 tbsp virgin coconut oil & 1 cup warm water
Coarse sea salt to taste',
'Step 1: Roasting the Kalu Pol Coconut Base - In a dry heavy cast-iron skillet over medium heat, toast the raw rice grains until popped and chalky. Add grated coconut, coriander seeds, cumin, fennel seeds, and curry leaves. Roast continuously, stirring constantly for 8-10 minutes until the coconut turns a uniform, deep chocolate dark-brown color without burning. Transfer to a granite mortar or spice grinder and grind while warm into an oily, dark aromatic paste.
Step 2: Goraka Paste Preparation - Soak dried black goraka pieces in boiling water for 15 minutes. Pound in a mortar into a smooth, pitch-black sour paste.
Step 3: Meat Inoculation & Dry Cure - Place the cubed pork belly into an earthenware pot (chatti). Add the dark roasted curry powder, roasted chili powder, black pepper, turmeric, ground goraka paste, pounded ginger-garlic, and 1.5 tsp coarse sea salt. Massage the marinade vigorously into the pork until every piece is black and evenly coated. Let marinate for 30 minutes.
Step 4: Tempering the Scent of Ceylon - Heat coconut oil in a deep pot over medium heat. Sauté sliced red onions, slit green chilies, pandan leaf, cinnamon quill, and fresh curry leaves for 4 minutes until golden and fragrant.
Step 5: High-Heat Sear & Fat Rendering - Add the marinated pork cubes to the sizzling aromatics. Crank the flame to high. Stir-fry vigorously for 8 minutes to sear the meat and render intrinsic pork fat from the belly cubes.
Step 6: Incorporating Kalu Pol & Braising - Stir the dark ground kalu pol coconut paste into the pot. Add 1 cup of warm water, stirring to lift any roasted fond from the bottom. Bring to a boil, then reduce heat to low, cover with the clay lid, and simmer gently for 35 minutes until the pork is fork-tender.
Step 7: Uncovered Reduction & Black Glaze - Remove the lid. Simmer uncovered over medium-low heat for 10 minutes, allowing the liquid to reduce into a rich, glossy, jet-black clinging gravy with spiced pork fat floating on top.
Step 8: Resting & Village Presentation - Extinguish the heat and allow the curry to rest for 15 minutes before serving. The flavor deepens dramatically upon resting. Serve alongside hot pol roti, string hoppers, or steaming red rice.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/a/ae/Wiener-Schnitzel02.jpg/960px-Wiener-Schnitzel02.jpg'),

(38, 17, 'Crispy Skin Pan-Seared Salmon with Asparagus & Lemon Herb Butter', 'Dinner', 'Norway / Modern European Coastal Cuisine', 20,
'2 fresh Atlantic salmon fillets (approx. 200g each, center-cut, skin on, scaled and pin-boned)
1 bunch young pencil asparagus (woody ends snapped off)
2 tbsp clarified butter (ghee) or high-smoke grape seed oil
2.5 tbsp cold European unsalted butter (cut into cubes)
1 tbsp fresh lemon juice & 1 tsp finely grated lemon zest
1 tbsp finely chopped fresh dill and chives
Flaky Maldon sea salt & freshly ground white pepper',
'Step 1: Scalpel-Drying the Salmon Skin - Lay salmon fillets skin-side up on a cutting board. Take the dull back of a chef''s knife and scrape the skin firmly from head to tail to squeegee out trapped water, wiping the blade on paper towels. A bone-dry skin is the absolute scientific key to shatteringly crisp fish skin.
Step 2: Precision Skin Scoring - Using a razor-sharp slicing knife, make 3 shallow, diagonal slashes (just through the skin, not into the pink flesh) across each fillet. This relieves skin tension during frying, preventing the fillet from curling.
Step 3: Pre-Sear Asparagus Blanch - Plunge trimmed asparagus into boiling salted water for 90 seconds, then shock in an ice bath to lock in chlorophyll green. Drain and dry thoroughly.
Step 4: Pan Conditioning & Initial Sear - Heat a 12-inch heavy stainless-steel or cast-iron skillet over medium-high heat until hot. Add clarified butter. Season the salmon skin with flaky sea salt. Lay fillets skin-side down gently into the pan away from you.
Step 5: The Flexible Fish Spatula Press - Immediately press down on the center of each fillet with a flexible slotted fish spatula with gentle, even pressure for 30 seconds. This holds the skin flat against the hot metal until the proteins set, ensuring complete, edge-to-edge skin contact with no cold pockets.
Step 6: The 85% Unilateral Cooking Method - Cook undisturbed on the skin side over medium heat for 6 to 7 minutes. Watch the side of the fillet: observe the opaque cooked flesh rise steadily from the bottom toward the top. Cook until 85% of the fillet is cooked through and the skin is visibly crisp and golden-brown.
Step 7: Sautéing Asparagus & Butter Baste - Add blanched asparagus spears to the empty side of the pan. Flip the salmon gently onto the flesh side. Immediately remove the skillet from heat! The residual pan heat will cook the flesh through in just 60 to 90 seconds for a succulent, translucent center (internal temp 125°F / 52°C). Drop cold butter, lemon juice, zest, and chopped dill around the asparagus, swirling the pan to emulsify.
Step 8: Plating & Presentation - Arrange the glossy glazed asparagus spears on warmed plates. Rest the salmon fillet diagonally across the spears, skin-side UP to preserve its crackling crispness. Drizzle lemon herb pan butter around the plate perimeter and finish with sea salt flakes.',
'assets/images/recipes/pan-seared-salmon.jpg'),

(39, 11, 'Classic Italian Lasagna Bolognese al Forno with Silky Béchamel', 'Dinner', 'Italy (Bologna, Emilia-Romagna)', 60,
'12 sheets fresh egg pasta lasagna sheets (or parboiled dry sheets)
For Traditional Ragù alla Bolognese: 300g minced beef chuck, 200g minced pork shoulder, 50g pancetta (finely minced), 1 finely minced soffritto (yellow onion, carrot, celery), 1 cup dry white wine, 1/2 cup whole milk, 2 tbsp tomato paste, 1 cup sieved passata, salt, black pepper
For Silky Béchamel (Besciamella): 4 tbsp unsalted butter, 4 tbsp all-purpose flour, 3 cups whole milk (warmed), 1/4 tsp freshly grated whole nutmeg, pinch of sea salt
1.5 cups freshly grated Parmigiano-Reggiano DOP (aged 24 months)',
'Step 1: The Soffritto & Meat Searing - In a heavy Dutch oven, render minced pancetta over low heat. Add the finely brunoised onion, celery, and carrot. Sauté for 8 minutes until sweet and translucent. Increase heat to high, add minced beef and pork, and break apart with a wooden spoon. Sear for 10 minutes until meat has browned in its own rendered fat with zero moisture remaining.
Step 2: Wine Deglaze & Milk Simmer - Pour in dry white wine, scraping up all caramelized fond from the bottom of the pot. Simmer until the wine has evaporated completely. Pour in 1/2 cup whole milk and simmer for 5 minutes (the lactic acid tenderizes the meat fibers). Stir in tomato paste and passata. Lower the heat to a bare whisper, cover, and braise for 2 hours, stirring occasionally until rich, velvety, and thick.
Step 3: Preparing the Velvety Besciamella - In a heavy saucepan, melt butter over medium-low heat. Whisk in all-purpose flour and cook the blond roux for 2 minutes. Gradually whisk in the warm whole milk in a steady stream, whisking constantly to eliminate lumps. Simmer for 6-8 minutes until thick enough to coat the back of a spoon (nappe consistency). Season with sea salt and freshly grated nutmeg.
Step 4: Dish Foundation - Preheat oven to 375°F (190°C). Lightly butter a 9x13-inch heavy ceramic or glass baking dish. Spread a thin layer of béchamel sauce across the bottom to prevent pasta sticking.
Step 5: Layering Technique (5 Tiers Minimum) - Lay down pasta sheets edge-to-edge. Spread a thin, even layer of rich Bolognese ragù across the pasta. Spoon luscious béchamel sauce over the meat and swirl gently. Shower with a snowfall of grated Parmigiano-Reggiano DOP.
Step 6: Repeating the Architecture - Repeat the layering process for at least 4 to 5 tiers: Pasta, Ragù, Béchamel, Parmigiano. Do not overfill each layer; authentic Bolognese lasagna is elegant, balanced, and structurally sound.
Step 7: The Crown Crust Layer - Finish the top layer with pasta sheets covered completely in béchamel sauce, small dollops of ragù, and a dense, generous crust of Parmigiano-Reggiano and tiny butter flecks.
Step 8: Baking & Crucial Set Rest - Bake uncovered for 28-32 minutes until the top is bubbling vigorously and develops deep golden-brown, crispy gratin blister spots. Remove from oven and let rest for 15 minutes before carving; resting allows the tiers to set into clean, distinct slices without collapsing.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/b/ba/Lasagne_-_stonesoup.jpg/960px-Lasagne_-_stonesoup.jpg'),

(40, 4, 'Authentic Indian Butter Chicken (Murgh Makhani) with Garlic Butter Naan', 'Dinner', 'India (Delhi - Moti Mahal Heritage, 1950s)', 45,
'750g boneless skinless chicken thighs (cut into large 1.5-inch tikka chunks)
For Tandoori Marinade: 1/2 cup thick Greek yogurt (hung curd), 2 tbsp mustard oil, 1.5 tbsp ginger-garlic paste, 1.5 tbsp Kashmiri chili powder, 1 tsp garam masala, 1 tsp roasted cumin powder, 1 tbsp lemon juice, 1 tsp salt
For Velvety Makhani Gravy: 1 kg ripe plum tomatoes (quartered), 4 green cardamom pods, 2 cloves, 1 cinnamon stick, 15 raw whole cashews (soaked in warm water), 1-inch fresh ginger (sliced), 4 cloves garlic, 1 tbsp Kashmiri chili powder, 4 tbsp unsalted Amul butter, 1/2 cup heavy cream, 1 tbsp crushed Kasuri Methi (sun-dried fenugreek leaves), 1 tsp honey, salt',
'Step 1: First & Second Tandoori Marinade - In a bowl, toss chicken with lemon juice, salt, and half the ginger-garlic paste; let sit 10 minutes. In a second bowl, whisk hung yogurt with mustard oil, Kashmiri chili powder, cumin, and garam masala. Combine with chicken and marinate for at least 45 minutes.
Step 2: Oven Charring (Tandoor Simulation) - Preheat oven to 450°F (230°C) with top broiler on high. Thread marinated chicken chunks onto metal skewers. Place on a wire rack over a foil-lined baking sheet. Broil for 10-12 minutes, turning once, until edges are charred with smoky tandoori black flecks while chicken is 80% cooked. Set aside.
Step 3: Tomato Base Simmer - In a saucepan, simmer quartered tomatoes, green cardamoms, cloves, cinnamon, soaked cashews, sliced ginger, garlic, Kashmiri chili powder, and 1/2 cup water for 20 minutes until tomatoes are completely soft and collapsed.
Step 4: Ultra-Fine Pureeing & Sieving - Discard whole cinnamon and cardamom pods. Transfer tomato-cashew mixture to a high-powered blender and purée on high for 2 minutes until smooth. Pass the purée through a fine-mesh chinois sieve into a clean bowl, using a ladle to press the sauce through. Discard all tomato skin seeds and fibrous residue to yield a velvet-smooth silk base.
Step 5: Butter Emulsification - In a wide skillet, melt 2 tablespoons butter over medium heat. Pour in the velvety sieved tomato sauce. Simmer for 10 minutes on medium-low heat until the sauce thickens and deepens in crimson tone.
Step 6: Chicken Integration & Simmer - Add the charred smoky chicken tikka pieces and any dripped juices into the simmering gravy. Cook gently for 6 minutes until chicken is completely tender and cooked through.
Step 7: The Kasuri Methi & Cream Finish - Rub dried Kasuri Methi (fenugreek leaves) between your palms to crush into a fine powder; sprinkle into the curry (this provides the signature butter chicken restaurant aroma). Stir in honey and 2 tablespoons cold butter. Swirl in heavy cream, stirring gently until the sauce transforms into a lustrous, creamy orange-crimson gravy.
Step 8: Plating & Royal Naan Service - Ladle hot butter chicken into a copper serving handi. Drizzle a swirl of fresh cream over the center and top with a small pat of butter. Serve alongside hot, blistered tandoori garlic butter naan.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/4/41/Butter_Chicken_%26_Butter_Naan_-_Home_-_Chandigarh_-_India_-_0006.jpg/960px-Butter_Chicken_%26_Butter_Naan_-_Home_-_Chandigarh_-_India_-_0006.jpg'),

(41, 20, 'Slow-Braised French Beef Short Ribs in Rich Burgundy Red Wine Sauce', 'Dinner', 'France (Burgundy / Bourguignon Tradition)', 60,
'4 thick English-cut bone-in beef short ribs (approx. 1.2 kg total, trimmed of excess hard surface fat)
1 full bottle (750ml) dry red wine (French Pinot Noir / Burgundy or Cabernet Sauvignon)
2 tbsp olive oil
1 large yellow onion, 2 carrots, 2 celery ribs (coarsely chopped into mirepoix chunks)
1 whole head garlic (halved horizontally)
2 tbsp tomato paste
3 cups rich veal stock or roasted beef bone broth
Herb Bouquet Garni: 4 sprigs thyme, 2 sprigs rosemary, 2 bay leaves (tied with kitchen twine)
Coarse sea salt and cracked tellicherry black pepper
Flat-leaf parsley for garnish',
'Step 1: Tempering & Meat Seasoning - Bring short ribs to room temperature for 30 minutes. Pat completely dry with paper towels. Season aggressively on all sides with coarse sea salt and freshly cracked black pepper.
Step 2: Deep Dutch Oven Searing - Heat olive oil in a heavy 6-quart enameled cast-iron Dutch oven over medium-high heat. Add the short ribs two at a time. Sear undisturbed for 3.5 minutes per side, turning with tongs to brown all four meat sides and the bone face until deeply caramelized and crusty. Transfer seared ribs to a plate.
Step 3: Caramelizing the Mirepoix - Pour off all but 2 tablespoons of rendered beef fat from the pot. Add the chopped onions, carrots, celery, and halved garlic heads. Sauté over medium heat for 6-8 minutes until vegetables are golden and softened.
Step 4: Tomato Paste Pincé - Add tomato paste to the vegetables. Cook, stirring constantly, for 2 minutes until the paste darkens to a brick-red color (pincé technique), sweetening the acidity and enhancing rich savory depth.
Step 5: Burgundy Wine Reduction - Pour the entire bottle of red wine into the pot, using a wooden spoon to vigorously scrape up all the savory browned bits (fond) stuck to the bottom. Bring to a rolling boil and simmer vigorously for 12-15 minutes until the wine reduces by half into a glossy, concentrated syrup.
Step 6: The Long Low-Heat Braise - Pour in rich veal stock or beef bone broth. Nest the seared short ribs bone-side UP into the liquid (the meat should be 80% submerged, not drowned). Tuck the herb bouquet garni between the ribs. Bring to a simmer, cover with a tight-fitting lid, and transfer to a preheated 325°F (165°C) oven for 3 hours, turning ribs once at the 2-hour mark, until the meat is fork-tender and pulls away effortlessly from the bone.
Step 7: Defatting & Sauce Reduction - Carefully lift the delicate short ribs from the braising liquid onto a plate and tent with foil. Strain the braising liquid through a fine chinois sieve into a saucepan, pressing on the mirepoix to extract juices; discard solids. Skim off surface fat. Simmer the strained sauce over medium-high heat for 8-10 minutes until it reduces to a glossy, dark mahogany glaze that coats the back of a spoon.
Step 8: Glazing & Plating - Spoon creamy buttery potato mousseline onto warm shallow bowls. Rest a braised short rib proudly on top. Generously ladle the glistening, velvety red wine reduction over the meat, letting it cascade into the potatoes. Garnish with minced fresh parsley.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/a/a1/Braised_Short_Ribs_low_%2818135093106%29.jpg/960px-Braised_Short_Ribs_low_%2818135093106%29.jpg'),

(42, 10, 'Authentic Neapolitan Pizza Margherita (Wood-Fired Style)', 'Dinner', 'Italy (Naples, Campania)', 20,
'For 24-Hour Fermented Dough: 500g Italian Tipo 00 flour (Caputo), 325ml cold water (65% hydration), 1.5g active dry yeast, 12g fine sea salt
For San Marzano Sauce: 1 can (400g) authentic San Marzano tomatoes DOP (crushed by hand, seasoned with 1/2 tsp sea salt only)
250g fresh Mozzarella di Bufala Campana or Fior di Latte (cut into strips and drained for 2 hours in a colander)
Fresh sweet Genovese basil leaves
2 tbsp cold-pressed extra virgin olive oil
Semolina flour for dusting the pizza peel',
'Step 1: High-Hydration Fermentation - Dissolve yeast in cold water. In a bowl, gradually incorporate Tipo 00 flour, adding salt halfway through. Knead for 10 minutes until silky and elastic. Let bulk ferment for 2 hours, divide into 250g smooth dough balls, and place in proofing boxes to ferment in the refrigerator for 24 hours to develop complex aromatic esters.
Step 2: Hand-Crushed San Marzano Sauce - Empty whole San Marzano tomatoes into a glass bowl. Crush the tomatoes delicately using your bare hands to preserve a rustic, pulpy texture. Season with 1/2 teaspoon fine sea salt. Never cook or purée with a machine, which introduces unwanted air and bitterness.
Step 3: Draining the Mozzarella - Cut fresh mozzarella into batons and let drain in a fine mesh sieve for 2 hours. Excess moisture turns artisan pizza soggy in high-heat ovens.
Step 4: Pizza Stone / Steel Saturation - Preheat your home oven to its absolute highest temperature (550°F / 290°C) with a thick baking steel or stone on the top rack for at least 60 minutes prior to baking.
Step 5: Hand-Stretching the Cornicione - Dust your work surface with coarse semolina flour. Place a room-temperature dough ball in the center. Using the pads of your fingers, press downward from the center outward, pushing the fermentation gas into the perimeter rim (cornicione). Gently lift and drape the dough over the backs of your hands, stretching in a circular motion until it reaches 11 to 12 inches in diameter with an ultra-thin translucent center.
Step 6: Classical Minimalist Topping - Transfer dough onto a lightly floured wooden pizza peel. Ladle 3 tablespoons of crushed San Marzano tomato sauce onto the center and spiral outward in a single fluid circular motion, leaving 1 inch of border untouched. Scatter drained mozzarella strips evenly across the tomato sauce. Drizzle a spiral of extra virgin olive oil over top.
Step 7: High-Heat Hearth Baking - Switch oven to top broiler on high. Shake the peel gently to ensure the dough moves freely, then slide the pizza directly onto the sizzling hot steel. Bake for 4 to 5.5 minutes: the crust will puff dramatically with large blisters (''leopard spots''), while the cheese melts into bubbling pools.
Step 8: Fresh Basil Dressing - Slide the pizza out with a metal peel. Immediately scatter 5 to 6 fresh sweet Genovese basil leaves over the bubbling cheese; the residual heat wilts the basil slightly, releasing pure essential oils. Slice into triangular quarters and serve piping hot.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/c/c8/Pizza_Margherita_stu_spivack.jpg/960px-Pizza_Margherita_stu_spivack.jpg'),

(43, 3, 'Authentic Sri Lankan Jaffna Lagoon Crab Curry (Kakuluwo Kari)', 'Dinner', 'Sri Lanka (Northern Province, Jaffna)', 45,
'1.2 kg fresh live blue swimming crabs or mud crabs (cleaned, top carapace halved, legs cracked lightly with a mallet)
3 tbsp virgin coconut oil
1 large red onion (finely chopped)
6 cloves garlic & 1.5-inch fresh ginger (pounded in a mortar)
3 fresh green chilies (slit lengthwise)
1 sprig fresh curry leaves & 1 stem moringa leaves (murunga kola)
1 piece Ceylon cinnamon quill & 1 tsp fenugreek seeds (uluhal)
3 tbsp authentic fiery Jaffna roasted curry powder (jaffna thuna paha)
1.5 tbsp roasted chili powder
1/2 tsp ground turmeric
2 tbsp wet tamarind pulp (soaked in 1/2 cup warm water)
1.5 cups thin coconut milk & 3/4 cup thick first-press coconut cream
Coarse sea salt to taste',
'Step 1: Crab Dressing & Shell Cracking - Clean fresh lagoon crabs: remove the apron, gills, and spongy stomach sac. Halve the main body and rinse gently under cold water. Use the flat side of a heavy cleaver to crack the thickest claws lightly once; this allows the intense spicy gravy to penetrate deep into the sweet claw meat.
Step 2: Spicing the Shells - Place the crab pieces into a large earthenware clay pot. Toss with turmeric, 1 tablespoon of the Jaffna roasted curry powder, and 1 teaspoon coarse sea salt; set aside for 15 minutes.
Step 3: Tempering with Fenugreek - Heat coconut oil in a wide, heavy clay pot over medium heat. Add fenugreek seeds, letting them sizzle for 15 seconds until aromatic and nutty (do not burn, or they turn bitter). Add chopped red onions, green chilies, fresh curry leaves, and cinnamon quill. Sauté for 4-5 minutes until onions are golden.
Step 4: Blooming the Jaffna Masala - Add pounded ginger-garlic paste, the remaining Jaffna roasted curry powder, and roasted chili powder into the hot oil. Stir-fry for 60 seconds to release the fiery toasted coriander, cumin, fennel, and chili aromatics.
Step 5: Crab Introduction & Shell Searing - Add the crab pieces and cracked claws into the fragrant spice base. Toss with large wooden spoons over high heat for 3 minutes until the dark crab shells transform into a vibrant, brilliant vermilion-orange color.
Step 6: Tamarind & Thin Coconut Milk Braise - Strain the tamarind pulp liquid into the pot, followed by the thin second-extract coconut milk. Bring to a rolling boil. Reduce heat to medium-low, cover, and simmer for 15 minutes so the crab juices mingle with the spicy tamarind liquor.
Step 7: Thick Coconut Cream & Moringa Leaves - Uncover the pot. Pour in the rich thick first-press coconut cream. Scatter fresh moringa leaves (murunga kola) over the surface (traditional Jaffna secret: moringa leaves impart a unique mineral herbal note that cuts the richness of crab). Simmer uncovered for 6-8 minutes until the gravy thickens to a glossy, rich coating.
Step 8: Resting & Murunga Service - Turn off heat and let rest for 15 minutes. Serve in the clay pot accompanied by steaming white parboiled rice, roast paan (wood-fired bread), or string hoppers.',
'https://upload.wikimedia.org/wikipedia/commons/c/c6/Chilli_crab-02.jpg'),

(44, 13, 'Crispy Chicken Parmesan with San Marzano Marinara & Melted Mozzarella', 'Dinner', 'Italy / Italian-American Little Italy Heritage', 30,
'2 large boneless skinless chicken breasts (approx. 450g total)
For Crisp Breading: 1/2 cup all-purpose flour, 2 large eggs (whisked with 1 tbsp whole milk), 1.5 cups Italian seasoned breadcrumbs mixed with 1/2 cup finely grated Parmigiano-Reggiano, 1/2 tsp garlic powder, salt and black pepper
1/3 cup extra virgin olive oil for pan shallow frying
1.5 cups slow-simmered San Marzano tomato marinara sauce
200g whole-milk low-moisture mozzarella cheese (freshly shredded or sliced)
1/2 cup grated Parmigiano-Reggiano DOP
Fresh sweet basil leaves for garnish',
'Step 1: Butterfly & Uniform Pounding - Slice each chicken breast horizontally in half to create 4 equal cutlets. Place cutlets between sheets of heavy plastic wrap. Using the flat face of a meat mallet, pound gently from the center outward to an exact uniform 1/4-inch thickness. Uniform thickness guarantees identical cooking time across the entire cutlet.
Step 2: Triple Breading Station - Set up three shallow bowls: Bowl 1 with seasoned flour; Bowl 2 with beaten egg wash; Bowl 3 with the breadcrumbs and grated Parmigiano-Reggiano mixture. Dredge chicken in flour, shake off excess; dip completely into egg wash; press firmly into breadcrumbs on both sides to create a dense, complete crust.
Step 3: Shallow Pan Frying - Heat olive oil in a wide 12-inch heavy stainless skillet over medium-high heat until oil registers 350°F (175°C). Add two breaded cutlets. Fry undisturbed for 3 minutes until deep golden-brown and intensely crisp. Flip and fry for 2.5 minutes on the reverse side. Transfer to a paper towel-lined wire rack.
Step 4: Baking Dish Foundation - Preheat oven to 425°F (220°C). Ladle 1/2 cup of hot San Marzano marinara sauce across the bottom of a wide ovenproof baking dish.
Step 5: Architectural Cutlet Layering - Lay the crispy fried chicken cutlets over the sauce in a single layer. Spoon 2 generous tablespoons of marinara sauce across the CENTER of each cutlet only—leave the outer perimeter crust uncovered by sauce so it remains shatteringly crisp during baking.
Step 6: Dual Cheese Crown - Top each cutlet with generous mounds of shredded low-moisture mozzarella, followed by a thick dusting of grated Parmigiano-Reggiano.
Step 7: High-Heat Gratin Bake - Transfer to the oven for 10-12 minutes until the mozzarella cheese is completely melted, bubbling furiously, and develops golden-brown blistered toasted spots under the broiler.
Step 8: Fresh Basil Service - Remove from oven, rest for 3 minutes, scatter with freshly torn sweet basil leaves, and serve hot with al dente spaghetti marinara.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/1/17/Chicken_parm_at_a_diner.jpg/960px-Chicken_parm_at_a_diner.jpg'),

(45, 12, 'Authentic Thai Green Chicken Curry (Gaeng Kiew Wan Gai)', 'Dinner', 'Thailand (Central Plains, Bangkok)', 30,
'500g boneless chicken thigh (cut into bite-sized pieces)
For Authentic Green Paste: 12 fresh green bird''s eye chilies, 3 shallots, 5 cloves garlic, 1 stalk lemongrass (sliced), 1 tbsp fresh galangal (chopped), 1 tsp kaffir lime peel, 1 tbsp coriander roots, 1 tsp toasted cumin, 1 tsp shrimp paste (kapi), 1 tsp salt
1 can (400ml) thick coconut cream (first press) & 1 cup coconut milk or light chicken stock
6 round Thai green eggplants (quartered) & 2 tbsp pea eggplants (makheua phuang)
4 fresh kaffir lime leaves (torn and bruised)
1.5 tbsp premium fish sauce (nam pla) & 1 tbsp shaved palm sugar
1 packed cup fresh Thai sweet holy basil leaves (horapha)
1 fresh red spur chili (julienned for garnish)
Steamed Jasmine rice for serving',
'Step 1: Stone Mortar Paste Pounding - In a heavy granite mortar, pound the green bird''s eye chilies and salt into a paste. Gradually add sliced galangal, lemongrass, kaffir lime peel, coriander roots, shallots, and garlic, pounding with firm downward wrist strokes until an aromatic, emerald-green paste forms. Blend in roasted cumin and fermented shrimp paste.
Step 2: Cracking the Coconut Cream (Taek Man) - Heat a heavy wok over medium heat. Add 1/2 cup of the thick coconut cream. Cook, stirring constantly for 5-6 minutes, until the water evaporates and the coconut cream ''cracks''—separating into clear, fragrant, simmering coconut oil.
Step 3: Frying the Green Paste - Add 3 generous tablespoons of the fresh green curry paste directly into the cracked coconut oil. Stir-fry for 3-4 minutes over medium heat until the paste releases its volatile aromatics and the oil turns a glistening emerald green.
Step 4: Poultry Searing - Add the sliced chicken thigh pieces to the sizzling paste. Stir-fry for 3 minutes until the chicken is coated in the green curry essence and the outer meat is sealed.
Step 5: Liquid Addition & Simmer - Pour in the remaining coconut milk and chicken stock. Bring to a gentle boil over medium heat.
Step 6: Vegetable & Herb Infusion - Drop in the quartered Thai green eggplants, pea eggplants, and bruised kaffir lime leaves. Simmer gently for 8 minutes until eggplants are tender but still hold their shape.
Step 7: Balancing the Thai Flavor Spectrum - Season the curry with premium fish sauce and shaved palm sugar. Taste: authentic green curry must exhibit a delicate balance of fiery chili heat, creamy coconut sweetness, and savory umami.
Step 8: Basil Wilt & Royal Service - Turn off the flame. Immediately fold in the fresh Thai sweet basil leaves, pressing them under the hot gravy for 10 seconds to retain their bright green color without blackening. Garnish with red chili ribbons and serve with hot Jasmine rice.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/e/e5/Thai_green_chicken_curry_and_roti.jpg/960px-Thai_green_chicken_curry_and_roti.jpg'),

(46, 25, 'Authentic Spanish Seafood Paella Valenciana with Saffron & Jumbo Shrimp', 'Dinner', 'Spain (Valencia - Albufera Coast)', 45,
'2.5 cups authentic Spanish Bomba or Calasparra short-grain rice
8 large jumbo wild prawns/shrimp (heads and shells on)
300g fresh Mediterranean mussels and clams (cleaned and debearded)
200g cleaned squid / calamari rings (sliced)
4 tbsp Spanish extra virgin olive oil
1 large ripe tomato (grated, discarding skin for sofrito)
4 cloves garlic (minced) & 1 tsp sweet Spanish pimentón (paprika)
1 generous pinch authentic Spanish saffron threads (approx. 30 threads, steeped in warm broth)
5 cups rich homemade seafood fumet or shellfish stock
1/2 cup sweet garden peas & fresh lemon wedges for garnish',
'Step 1: Steeping the Saffron & Hot Broth - Heat the seafood fumet in a saucepan. In a small mortar, grind the saffron threads with a pinch of coarse salt; pour 1/2 cup of the warm broth over the crushed saffron and let steep for 15 minutes to unlock its golden amber color and earthy aroma.
Step 2: Searing Shellfish in Paellera - Set a wide 15-inch carbon-steel paella pan (paellera) level over medium-high heat across two burners. Add olive oil. Sear jumbo prawns for 90 seconds per side until bright orange and charred; transfer to a plate. Sear squid rings for 1 minute; remove to plate.
Step 3: Developing the Sofrito - Lower heat to medium. Add minced garlic and grated tomato purée to the pan. Sauté for 5 minutes until the tomato water evaporates, leaving a thick, dark-red jammy sofrito. Stir in sweet pimentón for 30 seconds (do not burn).
Step 4: Distributing the Bomba Rice - Pour in the dry Bomba rice. Stir the rice continuously for 2 minutes to toast the grains in the olive oil and sofrito base (nacarar technique), coating every grain in savory fat.
Step 5: Broth Infusion & The Golden Rule - Pour in the hot saffron broth and remaining seafood fumet. Stir the rice thoroughly once to distribute grains evenly across the broad flat pan. Crucial culinary law: after this moment, never stir the rice again; stirring releases surface amylose starch, turning paella into risotto instead of distinct, dry grains.
Step 6: High-Heat Boil & Simmer - Boil vigorously over high heat for 8 minutes to set the grains, then lower heat to gentle simmer for 10 minutes until liquid is mostly absorbed.
Step 7: Shellfish Embedding & Creating ''Socarrat'' - Press mussels, clams, seared prawns, and squid into the top of the rice. Crank heat to high for 2 to 3 minutes: listen closely for a crackling, popping sound and smell a nutty toasted aroma. This indicates the formation of the legendary ''socarrat''—the prized caramelized crunchy crust on the bottom of the pan.
Step 8: The Linen Rest & Fiesta Service - Remove from heat, cover the entire pan with clean kitchen towels or butcher paper, and let rest undisturbed for 5 minutes. Serve straight from the paellera at the center of the table with fresh lemon wedges.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/e/ed/01_Paella_Valenciana_original.jpg/960px-01_Paella_Valenciana_original.jpg'),

(47, 1, 'Classic British Shepherd’s Pie with Golden Forked Mashed Potato Crust', 'Dinner', 'United Kingdom (England & Scotland Countryside)', 50,
'700g ground lamb (minced lamb shoulder with approx. 15% fat for authentic Shepherd''s Pie)
2 tbsp olive oil
1 large brown onion, 2 carrots, 2 stalks celery (finely brunoised)
3 cloves garlic (minced)
2 tbsp tomato paste
2 tbsp Worcestershire sauce (Lea & Perrins)
1.5 cups rich red wine (or dark beef stock)
1.5 cups rich lamb bone stock or beef stock
1 cup fresh sweet garden peas
2 sprigs fresh rosemary & 3 sprigs fresh thyme (minced)
For Velvety Potato Crest: 1 kg Russet or Maris Piper potatoes (peeled and boiled), 4 tbsp butter, 1/3 cup heavy cream, 2 egg yolks, 1/2 cup grated mature Cheddar or Parmesan, freshly grated nutmeg, salt and pepper',
'Step 1: High-Heat Lamb Searing - Heat olive oil in a large Dutch oven over high heat. Add the minced lamb in batches. Sear aggressively, breaking up clumps with a wooden spatula, for 8-10 minutes until deeply browned and caramelized. Drain off excess rendered lamb fat, leaving 2 tablespoons in the pot.
Step 2: Sautéing Mirepoix - Add the finely diced onion, carrots, celery, and minced garlic to the meat. Sauté over medium heat for 6-8 minutes until the vegetables soften and absorb the savory pan juices.
Step 3: Deglazing & Tomato Paste - Stir in tomato paste, Worcestershire sauce, minced rosemary, and thyme. Cook for 2 minutes. Pour in red wine, scraping up all the savory brown fond from the bottom of the pot. Simmer until the wine has reduced by two-thirds.
Step 4: Braising the Rich Lamb Gravy - Pour in the rich stock. Bring to a boil, reduce heat to low, and simmer uncovered for 25 minutes until the sauce thickens into a glossy, dark, unctuous stew. Stir in sweet peas during the last 2 minutes. Taste and adjust seasoning with salt and pepper.
Step 5: Potato Ricing & Egg Emulsion - Boil peeled potatoes in salted water until knife-tender; drain thoroughly and let steam dry in the colander for 3 minutes. Pass potatoes through a mechanical potato ricer into a bowl. Beat in warm butter, cream, egg yolks (which help the crest brown and hold peaks), half the grated cheese, salt, pepper, and a pinch of nutmeg until smooth.
Step 6: Dish Assembly - Transfer the hot lamb filling into a deep 9x13-inch ceramic baking dish. Smooth the top surface with a spatula and let sit for 5 minutes so a light skin forms on the meat.
Step 7: Piping & Fork Ridging - Pipe or dollop the warm mashed potatoes across the top. Using a fork, rake and groove the entire surface in decorative cross-hatch patterns to create numerous ridges. Sprinkle with remaining grated cheese.
Step 8: Baking & Broiling - Bake at 400°F (200°C) for 22 minutes until bubbling around the edges, then broil on high for 3 minutes until the fork ridges turn crispy, deeply golden, and blistered. Let stand 10 minutes before serving.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/5/52/Homerton_College_-_Shepherd%27s_pie_%28cropped%29.jpg/960px-Homerton_College_-_Shepherd%27s_pie_%28cropped%29.jpg'),

(48, 14, 'Authentic Sri Lankan Mutton Curry with Cinnamon, Cardamom & Toasted Spices', 'Dinner', 'Sri Lanka (Highlands & Uva Province)', 60,
'800g bone-in mutton or goat meat (cut into 1.5-inch curry portions)
3 tbsp virgin coconut oil
1 large red onion (thinly sliced)
6 cloves garlic & 2-inch fresh ginger (pounded in a mortar)
3 green bird''s eye chilies (slit lengthwise)
1 stalk lemongrass & 2-inch rampe (pandan leaf)
1 sprig fresh curry leaves
5 green cardamom pods, 4 cloves, 1 Ceylon cinnamon quill
3 tbsp dark roasted Sri Lankan meat curry powder
1.5 tbsp roasted chili powder & 1/2 tsp ground turmeric
1 tbsp crushed black peppercorns
1 tbsp tamarind paste or piece of goraka
1.5 cups thin coconut milk & 1/2 cup thick first-press coconut cream
Coarse sea salt to taste',
'Step 1: Meat Tenderization & Spicing - Wash mutton pieces and drain. In a large clay pot, rub the meat with roasted curry powder, roasted chili powder, turmeric, black pepper, pounded ginger-garlic paste, and 1.5 teaspoons salt. Let marinate for 30 minutes.
Step 2: Whole Spice Blooming - Heat coconut oil in a deep clay pot over medium heat. Add cracked cardamoms, cloves, cinnamon quill, lemongrass, and pandan leaf. Sauté for 1 minute until fragrant.
Step 3: Aromatics Sauté - Add sliced red onions, green chilies, and curry leaves. Fry for 5 minutes until onions turn deep golden-brown.
Step 4: High-Heat Meat Searing - Add marinated mutton into the sizzling pot. Sear over high heat for 8 minutes, stirring continuously to seal the meat and caramelize the spice crust.
Step 5: Slow Clay Pot Braise - Pour in thin coconut milk and tamarind paste. Bring to a rolling boil. Cover with clay lid, lower heat to low, and simmer for 40 to 45 minutes until mutton is meltingly tender and bone marrow enriches the sauce.
Step 6: Thick Coconut Cream Addition - Remove lid, pour in thick first-press coconut cream, and swirl pot gently.
Step 7: Gravy Thickening - Simmer uncovered over medium-low heat for 8 minutes until gravy is thick, dark crimson, and glossy with spiced coconut oil droplets on top.
Step 8: Traditional Service - Rest for 15 minutes. Serve hot with steaming samba rice, dhal curry, and pol sambol.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/6/67/Rogan_Josh_Kashmiri.jpg/960px-Rogan_Josh_Kashmiri.jpg'),

(49, 1, 'Grilled Honey Garlic Glazed Thick-Cut Pork Chops', 'Dinner', 'United States (Southern Barbecue Cuisine)', 25,
'2 thick bone-in center-cut pork rib chops (approx. 350g each, 1.25 inches thick)
2 tbsp olive oil
Coarse sea salt and cracked black pepper
For Honey Garlic Glaze: 1/3 cup raw clover honey, 5 cloves fresh garlic (finely minced), 2 tbsp apple cider vinegar, 2 tbsp low-sodium soy sauce, 1 tbsp unsalted butter, 1/2 tsp red chili flakes
1 sprig fresh rosemary
Charred lemon halves for serving',
'Step 1: Pork Brining & Drying - Let pork chops sit in a 5% salt-water brine for 20 minutes to maximize juiciness, then remove and pat completely dry on paper towels.
Step 2: Honey Garlic Reduction - In a small saucepan, melt butter over medium heat. Sauté minced garlic for 60 seconds until fragrant. Whisk in honey, apple cider vinegar, soy sauce, and red chili flakes. Simmer for 3 minutes until thick and glossy.
Step 3: Cast-Iron Preheating - Preheat a heavy ridged cast-iron grill pan over high heat until smoking.
Step 4: Fat Cap Rendering - Hold chops vertically with tongs to press the fat cap directly onto the hot grill pan for 90 seconds to render crispy crackling.
Step 5: Diamond Grill Mark Searing - Lay chops flat on the grill. Sear for 3.5 minutes, rotate 45 degrees, and sear for 2 minutes to create classic diamond grill marks.
Step 6: Flip & Glaze Application - Flip chops onto the reverse side. Brush generously with warm honey garlic glaze. Cook for 4 minutes while continuously basting with glaze until internal temperature reaches 142°F (61°C).
Step 7: Board Resting - Transfer chops to a cutting board and let rest for 6 minutes to allow juices to settle.
Step 8: Plating - Drizzle with remaining warm honey glaze and serve with charred lemon halves and grilled seasonal vegetables.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/2/2b/Pork_chops_167541218.jpg/960px-Pork_chops_167541218.jpg'),

(50, 13, 'Classic Beef Stroganoff over Buttered Egg Noodles with Sautéed Cremini', 'Dinner', 'Russia (Saint Petersburg - Stroganov Dynasty)', 30,
'600g beef tenderloin (filet mignon) or prime sirloin (sliced into 1/2-inch strips)
300g fresh cremini mushrooms (sliced 1/4-inch thick)
3 tbsp unsalted European butter
1 large shallot (finely minced) & 2 cloves garlic (minced)
1.5 cups rich beef bone broth
1/3 cup dry white wine or cognac
1 tbsp Dijon mustard & 1 tbsp Worcestershire sauce
3/4 cup authentic full-fat sour cream (smetana, room temperature)
350g wide egg noodles (cooked al dente and tossed with butter and parsley)
Fresh dill & chives for garnish',
'Step 1: Tenderloin Flash Searing - Heat 1 tablespoon butter in a wide skillet over high heat. Add beef strips in a single uncrowded layer. Flash-sear for 60 seconds per side until browned on the outside but still pink and tender inside. Transfer beef immediately to a warm side plate.
Step 2: Caramelizing Cremini Mushrooms - Melt 1 tablespoon butter in the same pan. Add sliced mushrooms. Sauté undisturbed for 4 minutes until deeply browned and caramelized. Add minced shallots and garlic; sauté for 2 minutes.
Step 3: Cognac Deglazing - Pour in dry white wine or cognac, scraping up all browned meat fond from the skillet bottom. Simmer until the alcohol evaporates completely.
Step 4: Broth Reduction - Pour in beef bone broth, Dijon mustard, and Worcestershire sauce. Simmer vigorously for 6 minutes until the liquid reduces by half into a rich savory sauce.
Step 5: Tempering the Sour Cream - In a small bowl, whisk 3 tablespoons of the hot pan sauce into the room-temperature sour cream to temper it (this prevents curdling when added to the pan).
Step 6: Sauce Emulsification - Lower heat to the lowest whisper. Whisk the tempered sour cream into the simmering mushroom sauce until silky, creamy, and velvety.
Step 7: Reintegrating Tenderloin - Return seared beef strips and resting juices into the sauce. Warm gently for 90 seconds without boiling.
Step 8: Wide Noodle Service - Swirl buttered parsley egg noodles into wide bowls. Ladle the hot beef stroganoff and mushrooms over top. Garnish with fresh chopped dill.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/9/95/Moscow_%288351271825%29.jpg/960px-Moscow_%288351271825%29.jpg'),

(51, 21, 'Classic French Poulet Rôti with Lemon, Rosemary & Rich Pan Jus', 'Dinner', 'France (Bresse / Classic Parisian Brasserie)', 60,
'1 whole organic farm chicken (approx. 1.6 kg / 3.5 lbs)
4 tbsp European cultured butter (softened at room temperature)
1 whole lemon (halved) & 1 head garlic (halved horizontally)
4 sprigs fresh rosemary & 4 sprigs fresh thyme
1 large yellow onion & 2 carrots (cut into thick chunks for roasting bed)
1 cup dry white wine & 1 cup rich chicken bone broth
Coarse sea salt & freshly ground black pepper',
'Step 1: Cavity Cleaning & Overnight Air-Dry - Remove chicken giblets. Pat cavity and skin completely dry with paper towels. Leave uncovered in refrigerator for 6 hours to dry the skin for maximum crispiness.
Step 2: Compound Herb Buttering - In a bowl, mash softened butter with minced rosemary, thyme leaves, salt, and pepper. Gently slide fingers under the breast skin to separate it from the meat. Spread the herb butter directly over the breast meat under the skin.
Step 3: Cavity Aromatics - Season cavity with salt and pepper. Stuff with halved lemon, garlic halves, and rosemary sprigs.
Step 4: Kitchen Twine Trussing - Truss chicken tightly with cotton kitchen twine, tying legs together and tucking wing tips under the back for uniform roasting.
Step 5: Vegetable Trivet Foundation - Arrange thick chunks of carrots, onions, and remaining garlic in a heavy roasting pan. Place trussed chicken breast-side up on top of vegetables.
Step 6: High-Heat Blistering & Slow Roasting - Roast in a 425°F (220°C) oven for 20 minutes to blister the skin golden, then reduce oven to 375°F (190°C) and roast for 40 minutes, basting twice with pan juices until thickest part of thigh registers 165°F (74°C).
Step 7: Resting - Transfer roast chicken to a warm carving board. Let rest for 15 minutes before carving to allow juices to redistribute.
Step 8: Pan Jus Deglazing - Place roasting pan over medium heat on stovetop. Pour in white wine and chicken broth, scraping up caramelized drippings. Simmer for 5 minutes until glossy and slightly reduced. Carve chicken and serve with hot pan jus and roasted root vegetables.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/d/d9/Max%27s_Roasted_Chicken_-_Evan_Swigart.jpg/960px-Max%27s_Roasted_Chicken_-_Evan_Swigart.jpg'),

(52, 20, 'Decadent Molten Chocolate Lava Cake (Moelleux au Chocolat)', 'Dessert', 'France (Michel Bras Invention, Laguiole, 1981)', 25,
'200g premium bittersweet dark chocolate (Valrhona 70% cacao, chopped)
100g unsalted European high-fat butter (cut into cubes)
3 large farm-fresh eggs + 2 egg yolks (room temperature)
1/2 cup granulated sugar
2 tbsp unbleached all-purpose flour (sifted)
1 tsp pure Madagascar vanilla extract
1/4 tsp fine sea salt
Unsweetened Dutch-process cocoa powder & softened butter for coating ramekins
Powdered sugar & fresh raspberries for serving',
'Step 1: Ramekin Preparation & Non-Stick Shell - Brush the interiors of four 6-ounce ceramic ramekins thoroughly with softened butter using upward vertical brush strokes (this guides the cake as it rises). Dust generously with Dutch-process cocoa powder, rotating and tapping each ramekin to coat all sides evenly; invert and tap out excess. Chill ramekins in the refrigerator while preparing batter.
Step 2: Bain-Marie Chocolate Melting - Set a heatproof glass bowl over a saucepan of gently simmering water (the base of the bowl must not touch the water). Combine the chopped bittersweet dark chocolate and cubed butter. Stir slowly with a silicone spatula until melted into a glossy, velvety, lump-free ganache. Remove bowl from heat and let cool to lukewarm (approx. 100°F / 38°C).
Step 3: Aerating Eggs & Sugar (Sabayon Phase) - In a separate stand mixer bowl fitted with the whisk attachment, beat the 3 whole eggs, 2 egg yolks, granulated sugar, and sea salt on medium-high speed for 4-5 minutes until pale, thick, and ribbon-stage.
Step 4: Emulsifying Chocolate & Batter - Pour the lukewarm melted chocolate mixture into the whipped egg sabayon along with vanilla extract. Fold gently using wide, sweeping figure-eight motions with a spatula until completely incorporated without deflating the trapped air bubbles.
Step 5: Sifting Flour Fold - Sift the all-purpose flour over the chocolate batter. Fold delicately just until the flour disappears. Crucial pastry law: never overmix, as gluten development toughens the delicate sponge.
Step 6: Ramekin Filling & Oven Calibration - Divide batter equally among the four chilled ramekins, filling each three-quarters full. Preheat convection oven to 425°F (220°C). Place ramekins on a heavy baking sheet on the center rack.
Step 7: Precision Baking Window - Bake for exactly 11 to 12 minutes. Observe: the edges of the cakes should be firm, puffed, and set, while the center dime-sized circle remains soft and gently jiggles when the tray is nudged.
Step 8: The Unmolding & Molten Service - Remove from oven and let rest in ramekins for exactly 60 seconds (no longer, or carryover heat will cook the molten core). Run a thin offset knife around the top edge. Invert a warm dessert plate over each ramekin, flip in one smooth motion, tap the bottom gently, and lift the ramekin. Dust with powdered sugar and serve immediately while the rich chocolate center flows like molten lava upon the first spoon strike.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/6/6b/Chocolate_Fondant.jpg/960px-Chocolate_Fondant.jpg'),

(53, 7, 'Authentic Sri Lankan Watalappan (Spiced Coconut & Kithul Jaggery Custard)', 'Dessert', 'Sri Lanka (Sri Lankan Malay & Moor Heritage)', 50,
'400g authentic dark Sri Lankan Kithul palm jaggery (pure sap jaggery, finely shaved)
1.25 cups thick first-press fresh coconut cream (miti kiri, extracted from fresh coconut)
6 large farm-fresh eggs (at room temperature)
1/2 tsp freshly ground green cardamom powder (freshly cracked pods)
1/4 tsp freshly grated whole nutmeg
1/4 tsp ground mace
1 tbsp fragrant culinary rosewater
1/4 tsp fine sea salt
1/2 cup raw cashew nuts (split, for steaming and roasting garnish)',
'Step 1: Melting Kithul Jaggery Syrup - In a heavy-bottomed saucepan, combine the shaved dark Kithul jaggery with 3 tablespoons of water. Heat gently over medium-low heat, stirring constantly until the jaggery melts into a thick, fragrant, smoky amber-brown syrup. Remove from heat and allow to cool completely to room temperature.
Step 2: Whisking the Egg Base - In a large ceramic bowl, crack all 6 eggs. Whisk gently with a wire whisk for 60 seconds just until the whites and yolks are fully combined. Avoid creating excessive frothy bubbles, as trapped air causes large craters instead of the coveted fine honeycomb sponge texture.
Step 3: Straining the Syrup - Pour the cooled Kithul jaggery syrup through a fine-mesh sieve into the beaten eggs, whisking steadily to prevent thermal shock.
Step 4: Coconut Cream & Spice Infusion - Slowly whisk in the thick first-press coconut cream, ground green cardamom, freshly grated nutmeg, ground mace, culinary rosewater, and sea salt until the custard mixture is completely smooth and homogeneous.
Step 5: Chinois Double-Straining - Pass the entire liquid custard mixture through a fine-mesh chinois or double-layered cheesecloth into a pourable pitcher. This crucial step removes any chalazae (egg white cords) or unmelted jaggery bits, guaranteeing a silky custard texture.
Step 6: Dish Pouring & Foil Sealing - Pour the custard into an 8-inch round heatproof glass, stainless-steel, or ceramic baking dish. Scatter half of the split raw cashews gently across the surface (they will float on the dense custard). Cover the dish tightly with a double layer of aluminum foil, crimping the edges securely around the rim to prevent condensation water from dripping onto the custard surface.
Step 7: Gentle Water Bath Steam (Bain-Marie) - Set the dish inside a large steamer over boiling water (or in a water bath inside a 325°F / 165°C oven with boiling water halfway up the sides of the dish). Steam gently on low heat for 40 to 45 minutes until a toothpick inserted into the center emerges clean and the custard is set with a tender, silky jiggle.
Step 8: Chilling & Golden Cashew Garnish - Remove from steamer and cool on a wire rack to room temperature, then refrigerate for at least 4 hours (or overnight) to allow the spices and jaggery sugars to mature. Toast remaining cashew nuts in a dry pan until golden brown. Garnish the chilled watalappan with the toasted cashews and slice into wedges or scoop with a silver spoon.',
'assets/images/recipes/sri-lankan-watalappan.jpg'),

(54, 11, 'Classic Italian Tiramisu al Mascarpone with Espresso & Savoiardi', 'Dessert', 'Italy (Treviso, Veneto - Le Beccherie Heritage)', 30,
'500g authentic Italian Mascarpone cheese (chilled)
5 large farm-fresh egg yolks + 3 egg whites (strictly fresh, room temperature)
3/4 cup granulated sugar
1.5 cups freshly brewed strong Italian espresso (cooled to room temp)
2 tbsp Marsala wine or dark aged rum (optional)
30 authentic Italian Savoiardi ladyfinger biscuits (crisp, sugar-crusted)
3 tbsp premium unsweetened Dutch-process cocoa powder (for dusting)
Finely grated dark chocolate (Valrhona 70%) for interior layer',
'Step 1: Espresso & Marsala Infusion - Brew fresh Italian espresso using a moka pot. Pour into a wide, shallow glass dish. Stir in Marsala wine and let cool to room temperature. A shallow vessel allows effortless horizontal dipping of the ladyfinger biscuits.
Step 2: Sabayon Whipping - In a large bowl set over a pot of barely simmering water (bain-marie), whisk egg yolks and granulated sugar constantly for 5-6 minutes until pale, doubled in volume, and sugar is dissolved. Remove from heat and let cool to room temperature.
Step 3: Mascarpone Incorporation - In a separate bowl, gently loosen the chilled mascarpone with a spatula. Add the mascarpone to the cooled yolk sabayon in two additions, folding gently until completely smooth and velvety without overworking (overworking causes mascarpone fat to separate).
Step 4: Egg White Whipping - In a clean, grease-free stainless-steel bowl, whip the 3 egg whites with a balloon whisk until stiff peaks form. Delicately fold the whipped egg whites into the mascarpone cream in three batches using sweeping circular motions until an airy, cloud-like mousse is achieved.
Step 5: The Two-Second Ladyfinger Dip - Take one Savoiardi ladyfinger biscuit. Dip it into the cooled espresso for exactly 1 second on each side (never soak, or the biscuits will dissolve into mush). The core must remain firm to absorb moisture from the cream as it rests.
Step 6: First Tier Assembly - Arrange the dipped ladyfingers tightly in a single layer across the bottom of an 8x11-inch rectangular glass or ceramic dish. Spread half of the luscious mascarpone mousse evenly over the biscuits with an offset spatula. Scatter a light dusting of grated dark chocolate over top.
Step 7: Second Tier Assembly - Repeat with a second layer of espresso-dipped ladyfingers arranged perpendicular to the first layer. Spread the remaining mascarpone cream smoothly across the top (or pipe decorative mounds using a round pastry tip).
Step 8: 6-Hour Maturation & Cocoa Dusting - Cover loosely with plastic wrap and refrigerate for at least 6 hours (ideally 12 hours) so the biscuits soften into a cake-like crumb while the mascarpone sets. Right before serving, dust the entire top with an opaque, velvety layer of Dutch-process cocoa powder through a fine-mesh tea sieve. Slice and serve chilled.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/5/58/Tiramisu_-_Raffaele_Diomede.jpg/960px-Tiramisu_-_Raffaele_Diomede.jpg'),

(55, 17, 'Creamy New York Style Baked Cheesecake with Graham Cracker Crust', 'Dessert', 'United States (New York City - Arnold Reuben Tradition, 1929)', 60,
'For Buttery Graham Crust: 2 cups graham cracker crumbs (finely ground), 6 tbsp unsalted butter (melted), 3 tbsp sugar, 1/4 tsp salt
For Dense Cream Cheese Filling: 900g full-fat cream cheese (Philadelphia, room temperature), 1.25 cups granulated sugar, 1/3 cup sour cream (full fat, room temp), 2 tbsp all-purpose flour, 1 tbsp pure vanilla extract, 1 tsp fresh lemon juice & 1 tsp lemon zest, 4 large eggs + 1 egg yolk (room temperature)
For Sour Cream Glaze: 1 cup sour cream, 2 tbsp powdered sugar, 1 tsp vanilla extract',
'Step 1: Crust Compacting & Blind Bake - Mix graham cracker crumbs, melted butter, sugar, and salt until it resembles wet sand. Press firmly into the bottom and 1 inch up the sides of a 9-inch springform pan using the flat base of a measuring cup. Bake at 350°F (175°C) for 10 minutes until fragrant and golden; cool completely.
Step 2: Waterproofing the Springform Pan - Wrap the exterior base and sides of the springform pan in three layers of heavy-duty aluminum foil to ensure complete waterproofing for the water bath.
Step 3: Low-Speed Cream Cheese Beating - In a stand mixer fitted with the paddle attachment, beat the room-temperature cream cheese, sugar, and flour on lowest speed for 3 minutes until smooth and lump-free. Crucial technique: beat only on low to prevent whipping air into the batter, which causes cracks during baking.
Step 4: Liquid Emulsion - Add sour cream, vanilla extract, lemon juice, and lemon zest; mix on low speed for 60 seconds until incorporated.
Step 5: Egg Addition - Add the eggs and egg yolk one at a time, mixing on low speed just until each yolk disappears. Tap the bowl firmly on the counter three times to release any trapped air bubbles.
Step 6: Bain-Marie Water Bath Setup - Pour filling over the cooled crust. Place springform pan inside a large high-sided roasting pan. Place the roasting pan on the center oven rack. Carefully pour boiling kettle water into the roasting pan until it reaches halfway up the sides of the springform pan.
Step 7: Low & Slow Baking - Bake at 325°F (165°C) for 65 to 75 minutes until the edges are set and slightly golden, but the center 3-inch ring jiggles slightly like set gelatin.
Step 8: The Gradual Oven Cool-Down - Turn off the oven. Prop the oven door open 2 inches with a wooden spoon and leave the cheesecake inside undisturbed for 60 minutes. Then cool on a wire rack to room temp, and chill in the refrigerator for at least 8 hours. Release springform ring, slice with a hot wet knife, and serve.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/e/ea/Baked_cheesecake_with_raspberries_and_blueberries.jpg/960px-Baked_cheesecake_with_raspberries_and_blueberries.jpg'),

(56, 2, 'Warm Cinnamon Spiced Apple Crisp with Rolled Oat Pecan Streusel', 'Dessert', 'United States / United Kingdom (Country Hearth Tradition)', 45,
'6 large firm baking apples (Honeycrisp & Granny Smith, peeled, cored, and sliced 1/4-inch thick)
2 tbsp fresh lemon juice & 1 tsp lemon zest
1/3 cup granulated sugar & 1 tbsp cornstarch
1.5 tsp ground Ceylon cinnamon & 1/4 tsp ground nutmeg
For Shatteringly Crisp Streusel: 1 cup old-fashioned rolled oats, 3/4 cup all-purpose flour, 2/3 cup dark brown sugar, 1/2 cup chopped raw pecans, 1/2 cup cold unsalted butter (cut into 1/2-inch cubes), 1/2 tsp fine sea salt
Artisanal vanilla bean gelato for serving',
'Step 1: Apple Selection & Slicing - Peel, core, and slice Honeycrisp and Granny Smith apples into uniform 1/4-inch wedges. Combining tart Granny Smith with sweet Honeycrisp provides the ultimate balance of flavor and structural integrity.
Step 2: Apple Maceration - In a large bowl, toss apple slices with fresh lemon juice, lemon zest, granulated sugar, cornstarch, 1 teaspoon cinnamon, and nutmeg. Let macerate for 15 minutes; the cornstarch binds with natural pectin juices to create a thick, glossy fruit syrup during baking.
Step 3: Creating the Cold Oat Streusel - In a separate bowl, whisk rolled oats, flour, dark brown sugar, chopped pecans, remaining cinnamon, and salt. Add the cold cubed butter.
Step 4: Rubbing the Streusel Pebbles - Using a pastry blender or your fingertips, rub the cold butter into the dry ingredients until uneven clumps and pea-sized buttery nuggets form. Chill the streusel in the refrigerator for 10 minutes to keep butter cold.
Step 5: Dish Assembly - Butter a 9-inch deep ceramic pie dish or cast-iron skillet. Transfer the macerated apples and all accumulated sweet juices into the dish, pressing down gently into an even layer.
Step 6: Streusel Distribution - Scatter the chilled oat-pecan streusel generously over the apples in an even blanket, completely covering the fruit.
Step 7: Golden Convection Baking - Bake at 350°F (175°C) for 40 to 45 minutes until the fruit juices bubble vigorously around the perimeter and the oat streusel turns deep golden-brown, nutty, and crunchy.
Step 8: Hearthside Service - Cool for 10 minutes. Scoop warm portions onto dessert plates, crown with a generous scoop of artisanal vanilla bean gelato, and serve immediately.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/f/f7/Fresh_baked_apple_crisp_01.jpg/960px-Fresh_baked_apple_crisp_01.jpg'),

(57, 13, 'Traditional French Crème Brûlée with Madagascar Vanilla & Glass Sugar Crust', 'Dessert', 'France (François Massialot Heritage, 1691)', 40,
'2 cups heavy whipping cream (strictly 36% to 40% butterfat)
1 whole plump Madagascar vanilla bean (split lengthwise and seeds scraped)
5 large farm-fresh egg yolks (room temperature)
1/3 cup superfine baker''s sugar (caster sugar)
1/4 tsp fine sea salt
4 tbsp turbinado or extra-fine granulated sugar (for torching the caramel crust)',
'Step 1: Vanilla Bean Steeping - In a heavy saucepan, combine heavy cream, scraped vanilla bean caviar seeds, and the empty vanilla pod. Heat over medium heat until tiny bubbles form around the perimeter (approx. 180°F / 82°C). Remove from heat, cover pan with a lid, and allow to steep for 20 minutes to extract floral vanilla essence.
Step 2: Yolk & Sugar Ribbon Stage - In a heatproof ceramic bowl, gently whisk the egg yolks, superfine sugar, and sea salt with a fork or small whisk for 60 seconds until combined and pale. Avoid rapid whipping to prevent incorporating air bubbles.
Step 3: Slow Tempering - Discard the vanilla pod from the warm cream. Pour 1/3 cup of warm cream into the egg yolk mixture while whisking constantly. Slowly whisk in the remaining cream in a thin, continuous stream until fully emulsified.
Step 4: Chinois Straining & Skimming - Pour the custard through a fine-mesh chinois into a glass pitcher. Skim off any tiny surface bubbles with a clean paper towel or kitchen torch to ensure a mirror-smooth top.
Step 5: Shallow Ramekin Filling - Divide custard among four shallow, wide ceramic crème brûlée ramekins (shallow ramekins ensure the ideal 1:1 ratio of crunchy sugar crust to silky custard).
Step 6: Water Bath Steam Baking - Place ramekins inside a deep baking dish. Pour boiling water into the dish until it reaches halfway up the sides of the ramekins. Bake at 300°F (150°C) for 30 to 35 minutes until the edges are set and center jiggles gently like firm gelatin.
Step 7: Chilling - Remove ramekins from water bath, cool on a wire rack, and refrigerate uncovered for at least 4 hours until thoroughly cold.
Step 8: The Culinary Torch Caramelization - Sprinkle 1 tablespoon of sugar evenly over each cold custard, tilting to coat the entire surface and tapping out excess. Ignite a butane culinary blowtorch. Hold the blue flame 2 inches from the surface, moving in slow circular motions until the sugar melts, bubbles, and turns into a deep amber-golden caramel. Let sit for 90 seconds so the molten sugar hardens into a glass-like shell that shatters audibly with the tap of a spoon.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/1/17/2014_0531_Cr%C3%A8me_br%C3%BBl%C3%A9e_Doi_Mae_Salong_%28cropped%29.jpg/960px-2014_0531_Cr%C3%A8me_br%C3%BBl%C3%A9e_Doi_Mae_Salong_%28cropped%29.jpg'),

(58, 19, 'Fudgy Valrhona Dark Chocolate Chunk Brownies with Flaky Sea Salt', 'Dessert', 'United States (Chicago - Palmer House Hotel, 1893)', 35,
'200g European unsalted butter (melted and kept hot)
250g premium dark chocolate (Valrhona 70%, half melted, half chopped into rough chunks)
1 cup granulated sugar & 1/2 cup packed dark brown sugar
3 large eggs + 1 egg yolk (room temperature)
3/4 cup Dutch-process unsweetened cocoa powder (sifted)
1/2 cup unbleached all-purpose flour
1 tsp pure vanilla extract
1/2 cup raw walnuts (lightly toasted and coarsely chopped)
1 tsp flaky Maldon sea salt',
'Step 1: Pan Preparation - Line an 8x8-inch metal baking pan with parchment paper, leaving a 2-inch overhang on all sides for effortless lifting. Lightly grease parchment with butter.
Step 2: Hot Butter Chocolate Melt - In a heatproof bowl, combine hot melted butter with half of the chopped dark chocolate. Let sit for 60 seconds, then whisk until smooth, glossy, and melted.
Step 3: The Shiny Paper-Crust Secret - In a stand mixer, beat the eggs, egg yolk, granulated sugar, and brown sugar on high speed for 6 full minutes until pale, thick, and ribbony. This extended whipping dissolves the sugar crystals and creates the iconic shiny, tissue-paper-thin crinkle crust on top of the brownies.
Step 4: Emulsifying Chocolate Base - Pour the melted butter-chocolate mixture and vanilla into the whipped egg matrix. Fold gently with a wide silicone spatula until uniform.
Step 5: Dry Sifting & Gentle Fold - Sift Dutch-process cocoa powder and all-purpose flour over the batter. Fold with gentle strokes just until dry streaks disappear.
Step 6: Folding Chunks & Walnuts - Gently fold in the remaining dark chocolate chunks and toasted chopped walnuts.
Step 7: Baking Window - Spread batter into the prepared pan and smooth the top. Bake at 350°F (175°C) for 26 to 28 minutes until a toothpick inserted 1 inch from the edge comes out clean, but a toothpick inserted in the center emerges with moist, fudgy crumbs (not wet batter).
Step 8: Salt Finishing & Clean Slice - Scatter flaky Maldon sea salt over the hot brownies immediately upon removing from the oven. Let cool completely in the pan for 2 hours, then refrigerate for 1 hour for clean, razor-sharp squares. Lift using parchment wings, slice with a hot chef''s knife, and serve.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/6/68/Chocolatebrownie.JPG/960px-Chocolatebrownie.JPG'),

(59, 7, 'Authentic Sri Lankan Milk Toffee (Kiri Toffee) with Roasted Cashews & Cardamom', 'Dessert', 'Sri Lanka (Festive Heritage - Avurudu & Christmas)', 35,
'1 can (395g) sweetened full-cream condensed milk (Nestlé Milkmaid)
350g granulated cane sugar (approx. 1.75 cups)
1/2 cup fresh whole milk
2 tbsp pure cow ghee or unsalted butter
1/2 cup raw cashew nuts (split, dry-roasted, and coarsely crushed)
1/2 tsp freshly ground green cardamom powder
1 tsp pure vanilla extract
Ghee for greasing baking tray',
'Step 1: Tray Preparation - Thoroughly grease an 8x8-inch flat tray or baking dish with pure ghee. Set aside next to a smooth rolling pin or metal spatula.
Step 2: Pot Setup - In a heavy, wide non-stick saucepan or seasoned copper pot, combine condensed milk, granulated sugar, and fresh whole milk. Stir well with a heavy wooden spoon over medium-low heat until the sugar dissolves completely.
Step 3: Continuous Stirring Phase - Bring the mixture to a gentle boil. Lower the heat to medium-low. Stir continuously in steady figure-eight motions, scraping the bottom and sides constantly to prevent scorching.
Step 4: Color Evolution & Thickening - After 18-20 minutes, the mixture will thicken substantially, transform from milky white to a rich warm caramel-amber hue, and bubble with thick volcanic craters.
Step 5: Incorporating Ghee & Cashews - Add 2 tablespoons of ghee. Continue stirring vigorously. The mixture will begin to leave the sides and bottom of the pan in one cohesive mass. Immediately fold in crushed roasted cashews, ground cardamom, and vanilla extract.
Step 6: Reaching the Soft-Ball Stage - Cook for another 2-3 minutes until the toffee pulls away cleanly from the pan and forms a soft, glossy ball that rolls easily when pushed.
Step 7: Pouring & Rolling - Immediately pour the hot molten toffee onto the greased tray. Working quickly before it hardens, press and flatten with the back of a greased spatula or rolling pin to an even 3/4-inch thickness.
Step 8: Scoring & Diamond Carving - Let cool for 8 to 10 minutes until warm and semi-firm to touch. Using a sharp knife lightly greased with ghee, score and cut into traditional diamond-shaped lozenges. Allow to cool completely to harden into rich, crumbly, melt-in-the-mouth milk toffee.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/a/ad/Cannoli_siciliani_al_Caff%C3%A8_Impero%2C_ad_Alcamo.jpg/960px-Cannoli_siciliani_al_Caff%C3%A8_Impero%2C_ad_Alcamo.jpg'),

(60, 25, 'Classic Spanish Churros with Cinnamon Sugar & Thick Chocolate Dip', 'Dessert', 'Spain (Madrid & Andalusia - Chocolatería San Ginés Tradition)', 25,
'1 cup filtered water
4 tbsp unsalted butter (cut into cubes)
1 tbsp granulated sugar
1/2 tsp fine sea salt
1 cup unbleached all-purpose flour (sifted)
1 large egg (at room temperature)
1 tsp vanilla extract
Sunflower or canola oil for deep frying
For Coating: 1/2 cup granulated sugar mixed with 1.5 tsp ground Ceylon cinnamon
For Spanish Thick Hot Chocolate (Chocolate Caliente): 150g dark chocolate (70%), 1.5 cups whole milk, 1 tbsp cornstarch, 2 tbsp sugar',
'Step 1: Boiling the Water-Butter Base - In a heavy saucepan, combine water, cubed butter, sugar, and fine sea salt. Bring to a rolling boil over medium-high heat until the butter is completely melted.
Step 2: Scalding the Flour (Choux Paste Technique) - Remove saucepan from heat. Dump all sifted flour in at once. Stir vigorously with a heavy wooden spoon until a cohesive, smooth ball of dough forms and pulls away cleanly from the sides of the pan.
Step 3: Cooking Out the Starches - Return saucepan to low heat. Cook, stirring and flattening the dough against the bottom and sides for 90 seconds to cook out raw starch moisture. Remove from heat and cool for 4 minutes.
Step 4: Incorporating Egg - Beat in the egg and vanilla extract vigorously until completely absorbed and the dough transforms into a smooth, glossy, stiff paste that holds sharp peaks.
Step 5: Piping Setup - Fit a heavy canvas piping bag with an authentic closed-star piping tip (Wilton 1M or Ateco 846). Transfer warm dough into the bag.
Step 6: Deep Frying - Heat 3 inches of oil in a deep heavy pot to 365°F (185°C). Hold the piping bag directly over the hot oil. Pipe 5-inch lengths of dough, snipping the end cleanly with kitchen shears. Fry 4 to 5 churros at a time for 3 to 4 minutes, turning occasionally, until deep golden-brown and crisp on all ridges.
Step 7: Cinnamon Sugar Rolling - Lift fried churros with tongs, drain for 10 seconds on paper towels, then immediately roll in the cinnamon sugar mixture while hot so the sugar adheres.
Step 8: Spanish Chocolate Dip Service - Whisk chocolate, whole milk, cornstarch, and sugar in a small saucepan over medium heat until thick, dark, and glossy. Serve churros warm alongside small cups of the hot chocolate dip.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/c/c6/Chocolate_con_churros_%2827343655726%29.jpg/960px-Chocolate_con_churros_%2827343655726%29.jpg'),

(61, 12, 'Authentic Thai Mango Sticky Rice (Khao Niew Mamuang) with Sweet Coconut Cream', 'Dessert', 'Thailand (Bangkok & Central Plains Heritage)', 35,
'1.5 cups authentic Thai sweet glutinous sticky rice (Khao Niew, soaked in water for 4 hours)
1 can (400ml) premium thick coconut cream
1/2 cup granulated cane sugar & 1/2 tsp fine sea salt
2-inch pandan leaf (bruised and tied in a knot)
2 large ripe sweet Thai honey mangoes (Nam Dok Mai or Ataulfo, peeled and sliced)
1 tbsp split yellow mung beans (toasted in a dry pan until crunchy golden)
For Salty Coconut Drizzle: 1/2 cup thick coconut cream, 1/4 tsp salt, 1/2 tsp rice flour (simmered until thickened)',
'Step 1: Soaking Glutinous Rice - Soak Thai glutinous sticky rice in cold water for 4 to 6 hours. Drain thoroughly through a fine mesh colander. Long soaking softens the dense amylopectin starches for uniform steaming.
Step 2: Traditional Bamboo Steaming - Line a traditional cone bamboo steamer basket (huad) or cheesecloth-lined steamer tray with the soaked rice. Steam over boiling water for 22-25 minutes until the grains are translucent, tender, and slightly chewy (not mushy).
Step 3: Preparing Sweet Coconut Liquor - In a small saucepan over low heat, combine 1 cup thick coconut cream, cane sugar, sea salt, and knotted pandan leaf. Heat gently until the sugar is dissolved completely without letting the cream boil.
Step 4: Grain Saturation (The Infusion Step) - Transfer hot steamed sticky rice immediately into a clean ceramic bowl while still steaming. Pour the warm sweet coconut liquor over the rice. Stir gently with a rubber spatula to distribute liquid.
Step 5: Covered Maturation - Cover the bowl tightly with a lid or plastic wrap and let rest undisturbed for 25 minutes. During this rest, the hot rice grains slowly absorb the rich coconut cream, becoming plump, glistening, and sweet.
Step 6: Simmering Salty Drizzle Sauce - In a small saucepan, simmer 1/2 cup coconut cream with 1/4 tsp salt and rice flour for 2 minutes until glossy and thick. This salty sauce provides contrast to the sweet mango.
Step 7: Mango Peeling & Decorative Carving - Peel ripe golden mangoes. Slice the cheeks off each side of the flat pit. Slice each cheek crosswise on a bias into neat 1/4-inch fan slices.
Step 8: Thai Royal Presentation - Mold a mound of warm coconut sticky rice onto the serving plate. Arrange golden sliced mango fans alongside. Drizzle warm salty coconut sauce over the rice and scatter crunchy toasted yellow mung beans over the top.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/5/5d/Mango_sticy_rice_%283859549574%29.jpg/960px-Mango_sticy_rice_%283859549574%29.jpg'),

(62, 17, 'Classic American Mile-High Lemon Meringue Pie with Fluffy Toasted Cloud Meringue', 'Dessert', 'United States (Elizabeth Goodfellow Tradition, Philadelphia, 1806)', 45,
'1 blind-baked 9-inch all-butter flaky pie crust (fully baked and cooled)
For Silky Lemon Curd Filling: 1 cup fresh lemon juice (strained), 1.25 cups water, 1.25 cups sugar, 1/2 cup cornstarch, 4 egg yolks, 3 tbsp butter, 1 tbsp lemon zest, 1/4 tsp salt
For Mile-High Swiss Meringue: 4 egg whites (room temp), 1 cup granulated sugar, 1/4 tsp cream of tartar, 1 tsp vanilla extract',
'Step 1: Blind Baking Pie Crust - Fully bake a 9-inch all-butter pie crust using pie weights at 375°F (190°C) until deep golden and crisp; cool completely.
Step 2: Lemon Curd Slurry - In a heavy saucepan, whisk sugar, cornstarch, salt, water, and fresh lemon juice until smooth.
Step 3: Thickening the Curd - Cook over medium heat, whisking constantly until the mixture boils, turns clear, and thickens substantially. Remove from heat.
Step 4: Yolk Tempering - Whisk 1/2 cup of hot lemon mixture into the beaten egg yolks, then return all to the pan. Cook for 2 minutes, whisking vigorously. Remove from heat, stir in butter and lemon zest, and pour directly into the warm baked pie shell.
Step 5: Whipping Swiss Meringue - In a heatproof bowl set over simmering water, whisk egg whites, sugar, and cream of tartar until sugar is dissolved and mixture registers 160°F (71°C).
Step 6: Beating to Stiff Glossy Peaks - Transfer to a stand mixer and whip on high speed for 5-6 minutes until billowy, stiff, glossy peaks form and bowl is cool to touch. Whip in vanilla.
Step 7: Sealing to Crust Edges - Spoon meringue over hot lemon filling, spreading it all the way to touch and anchor to the crust edges (this prevents the meringue from shrinking or weeping). Swirl into high decorative peaks with a spatula.
Step 8: Baking & Toasting - Bake at 350°F (175°C) for 10-12 minutes until peaks are toasted golden brown (or torch with a blowtorch). Cool for 2 hours at room temp, then chill 3 hours before slicing.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/3/34/Theres_always_room_for_pie_%287859650026%29.jpg/960px-Theres_always_room_for_pie_%287859650026%29.jpg'),

(63, 16, 'Classic Italian Vanilla Bean Panna Cotta with Wild Raspberry Coulis', 'Dessert', 'Italy (Piedmont, Langhe Region)', 20,
'2 cups heavy whipping cream (36% fat) & 1/2 cup whole milk
1/3 cup granulated sugar
1 whole Madagascar vanilla bean (split and seeds scraped)
2.25 tsp powdered gelatin (1 packet) or 3 sheets sheet gelatin
3 tbsp cold water (for blooming gelatin)
For Raspberry Coulis: 250g fresh wild raspberries, 3 tbsp sugar, 1 tsp fresh lemon juice',
'Step 1: Blooming Gelatin - Sprinkle powdered gelatin evenly over 3 tablespoons cold water in a small ramekin. Let sit undisturbed for 5 minutes until sponge-like and fully hydrated.
Step 2: Infusing Cream & Vanilla - In a saucepan, combine heavy cream, whole milk, sugar, vanilla bean caviar seeds, and the empty vanilla pod. Warm over medium heat, stirring until sugar dissolves, bringing to a bare simmer (do not boil). Remove from heat.
Step 3: Dissolving Gelatin - Remove vanilla pod. Add bloomed gelatin to the hot cream mixture. Whisk gently for 60 seconds until gelatin is completely dissolved with zero granules remaining.
Step 4: Strain & Cool - Pour cream mixture through a fine-mesh sieve into a glass measuring pitcher. Let cool on counter for 15 minutes, stirring occasionally to distribute vanilla bean specks.
Step 5: Ramekin Pouring & Chilling - Lightly grease four 6-ounce ceramic ramekins with neutral oil. Pour panna cotta mixture into ramekins. Cover with plastic wrap and refrigerate for at least 4 to 6 hours until gently set.
Step 6: Raspberry Coulis Preparation - In a small saucepan, simmer fresh raspberries, sugar, and lemon juice for 5 minutes until berries collapse. Purée and press through a fine sieve to remove seeds; chill.
Step 7: Unmolding Technique - Dip the base of each ramekin into warm water for 5 seconds. Run a thin knife around the top edge. Invert onto chilled dessert plates and tap gently to release.
Step 8: Plating & Garnish - Spoon ruby-red raspberry coulis around the unmolded panna cotta, garnish with fresh raspberries and a mint sprig, and serve cold.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/8/80/Panna_Cotta_with_cream_and_garnish.jpg/960px-Panna_Cotta_with_cream_and_garnish.jpg'),

(64, 17, 'Decadent Red Velvet Cupcakes with Tangy Cream Cheese Mousseline', 'Dessert', 'United States (Waldorf-Astoria / Southern American Tradition)', 30,
'2.5 cups cake flour (sifted)
1.5 cups granulated sugar
1 tsp baking soda & 1 tsp fine salt
2 tbsp Dutch cocoa powder
1 cup cultured buttermilk (room temperature)
2 large eggs (room temp)
1.25 cups vegetable oil
1 tsp distilled white vinegar & 1 tsp pure vanilla extract
1 tbsp red gel food coloring
For Cream Cheese Frosting: 250g cream cheese (softened), 100g butter (softened), 3 cups powdered sugar, 1 tsp vanilla',
'Step 1: Dry Sifting - In a large bowl, sift together cake flour, sugar, baking soda, fine sea salt, and Dutch-process cocoa powder.
Step 2: Wet Emulsion - In a separate bowl, whisk together buttermilk, eggs, vegetable oil, white vinegar, vanilla extract, and red gel food coloring until brilliantly crimson.
Step 3: Batter Folding - Pour wet ingredients into dry ingredients. Whisk gently just until smooth and homogeneous with no flour pockets. Do not overmix.
Step 4: Portioning - Line a 12-cup muffin tin with paper liners. Fill each cup 2/3 full with batter.
Step 5: Baking Window - Bake at 350°F (175°C) for 18 to 20 minutes until tops spring back when lightly touched and a toothpick comes out clean. Cool completely on wire rack.
Step 6: Cream Cheese Whipping - In a stand mixer, beat softened cream cheese and butter together for 3 minutes until pale and fluffy. Gradually add sifted powdered sugar and vanilla, beating on medium-high until silky smooth.
Step 7: Piping Swirl - Fit piping bag with a large open star tip. Pipe tall, billowy swirls of cream cheese frosting over cooled cupcakes.
Step 8: Garnish & Service - Crumble one un-frosted cupcake into fine crimson crumbs and sprinkle over the white frosting swirls for an artisanal finish.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/7/7d/Delicious_Red_Velvet_Cupcake.jpg/960px-Delicious_Red_Velvet_Cupcake.jpg'),

(65, 22, 'Classical French Strawberry Tart (Tarte aux Fraises with Crème Pâtissière)', 'Dessert', 'France (Parisian Pâtisserie Heritage)', 40,
'1 blind-baked 9-inch sweet shortcrust pastry shell (Pâte Sablée)
For Vanilla Crème Pâtissière: 2 cups whole milk, 1 vanilla bean (split and scraped), 4 egg yolks, 1/2 cup sugar, 3 tbsp cornstarch, 2 tbsp butter (softened)
500g fresh ripe strawberries (hulled and halved lengthwise)
For Red Currant Glaze: 1/3 cup red currant or apricot jelly melted with 1 tbsp water
Toasted sliced almonds for crust rim',
'Step 1: Pâte Sablée Baking - Blind-bake sweet shortcrust pastry in a fluted tart pan with removable bottom at 350°F (175°C) for 20 minutes until pale golden and crisp; cool completely.
Step 2: Crème Pâtissière Scalding - Heat whole milk and vanilla bean seeds in a saucepan until steaming.
Step 3: Whisking Thickener - In a bowl, whisk egg yolks, sugar, and cornstarch until pale and ribbony. Whisk in half of the hot milk to temper, then return all to saucepan.
Step 4: Cooking Pastry Cream - Cook over medium heat, whisking vigorously until bubbling and thick. Remove from heat, beat in softened butter, press plastic wrap directly onto surface, and chill for 2 hours.
Step 5: Shell Assembly - Spread smooth chilled crème pâtissière evenly into the cooled tart shell using an offset spatula.
Step 6: Concentric Strawberry Fan - Arrange hulled, halved fresh strawberries cut-side down in tight, overlapping concentric circles starting from the outer crust toward the center.
Step 7: Glass Fruit Glazing - Warm red currant or apricot jelly with 1 tbsp water. Brush gently over the strawberries with a pastry brush to create a glistening mirror shine.
Step 8: Almond Rim Finish - Press toasted sliced almonds around the pastry crust edge. Chill for 30 minutes, slice into wedges, and serve.',
'assets/images/recipes/french-strawberry-tart.jpg'),

(66, 14, 'Traditional Sri Lankan Bibikkan (Rich Coconut Jaggery Spiced Cake)', 'Dessert', 'Sri Lanka (Coastal Christian & Avurudu Heritage)', 55,
'400g dark Kithul jaggery (shaved)
2 cups freshly grated coconut (pol)
1 cup roasted semolina (sooji / rulan)
1/2 cup all-purpose wheat flour (sifted with 1 tsp baking powder)
2 large eggs (beaten)
1/2 cup chopped cashews, 1/2 cup chopped dates, 1/4 cup golden sultanas
1/4 cup candied winter melon (puhul dosi) or candied ginger (finely chopped)
1 tsp Ceylon cinnamon, 1/2 tsp ground cardamom, 1/4 tsp ground cloves, 1/4 tsp grated nutmeg
2 tbsp pure cow ghee
1/4 tsp sea salt',
'Step 1: Melting Kithul Jaggery - In a heavy saucepan, melt shaved Kithul jaggery with 1/4 cup water over medium heat until a thick, smoky syrup forms.
Step 2: Coconut Cooking (Pani Pol Base) - Add freshly grated coconut to the hot jaggery syrup. Cook over medium-low heat, stirring for 8-10 minutes until coconut absorbs the jaggery and turns dark glossy brown. Cool to lukewarm.
Step 3: Roasting Semolina - Dry-roast semolina in a pan over medium heat for 4 minutes until nutty and fragrant.
Step 4: Fruit & Nut Tossing - In a bowl, toss chopped cashews, dates, sultanas, and candied melon with 1 tbsp flour to prevent sinking.
Step 5: Batter Incorporation - Combine the coconut-jaggery mixture with roasted semolina, flour, baking powder, spices, and salt. Stir in beaten eggs, melted ghee, and fruit-nut mixture until a dense, fragrant batter forms.
Step 6: Pan Preparation - Line an 8x8-inch cake pan with parchment paper and grease with ghee. Spread the dense batter evenly into the pan. Decorate top with whole split cashews.
Step 7: Slow Oven Baking - Bake at 325°F (165°C) for 45 to 50 minutes until firm and a skewer inserted in center emerges clean.
Step 8: Cooling & Slicing - Cool completely in pan for 2 hours. Slice into rich, dark squares. Flavors mature and improve over 24 hours.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/4/40/Strudel.jpg/960px-Strudel.jpg'),

(67, 1, 'Warm British Sticky Toffee Date Pudding with Rich Butterscotch Sauce', 'Dessert', 'United Kingdom (Lake District, Cumbria - Sharrow Bay, 1970s)', 45,
'200g Medjool dates (pitted and finely chopped)
1 cup boiling water & 1 tsp baking soda
6 tbsp unsalted butter (softened at room temp)
3/4 cup dark Muscovado or dark brown sugar
2 large eggs (room temp)
1.5 cups all-purpose flour & 1.5 tsp baking powder
1 tsp vanilla extract & 1/4 tsp salt
For Unctuous Toffee Sauce: 1 cup heavy whipping cream, 1/2 cup dark brown sugar, 1/2 cup butter, 1 tbsp dark treacle or golden syrup, pinch of sea salt
Double cream or clotted cream for serving',
'Step 1: Softening Medjool Dates - In a heatproof bowl, combine chopped dates, boiling water, and baking soda. Let sit for 15 minutes; the baking soda softens tough date fibers and releases natural sugars.
Step 2: Creaming Butter & Sugar - In a stand mixer, cream softened butter and dark Muscovado sugar on high speed for 4 minutes until light and fluffy.
Step 3: Egg Incorporation - Beat in eggs one at a time, followed by vanilla extract.
Step 4: Folding Batter - Sift flour, baking powder, and salt. Fold into creamed butter alternately with the soaked date mixture (liquid included) until a rich, moist batter forms.
Step 5: Baking Sponge - Pour into a buttered 8x8-inch ceramic baking dish. Bake at 350°F (175°C) for 30 to 35 minutes until a skewer inserted in the center comes out clean.
Step 6: Boiling Toffee Sauce - In a saucepan over medium heat, melt butter, dark brown sugar, heavy cream, and treacle. Bring to a boil, stirring constantly for 3 minutes until thick, glossy, and caramel-scented.
Step 7: Skewer Pricking & Sauce Soak - Prick holes all over the hot baked sponge with a wooden skewer. Pour half of the hot toffee sauce over the warm cake; let soak in for 10 minutes.
Step 8: Broil & Service - Spoon warm pudding onto plates, douse with remaining warm toffee sauce, and serve with double cream or vanilla ice cream.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/b/b3/Sticky_toffee_pudding_at_the_Black_Swan_-_Stierch.jpg/960px-Sticky_toffee_pudding_at_the_Black_Swan_-_Stierch.jpg'),

(68, 29, 'Authentic Portuguese Custard Tarts (Pastéis de Nata / Belém Style)', 'Dessert', 'Portugal (Santa Maria de Belém, Lisbon - Hieronymites Monastery, 1837)', 35,
'500g all-butter puff pastry (rolled into a tight log and sliced into 12 rounds)
For Portuguese Custard Filling: 1 cup whole milk, 1 cup heavy cream, 3 tbsp all-purpose flour, 1 cup sugar, 1/2 cup water, 1 cinnamon stick, 1 strip lemon peel (yellow zest only), 6 large egg yolks (room temperature)
Ground Ceylon cinnamon and powdered sugar for dusting',
'Step 1: Infusing Lemon-Cinnamon Sugar Syrup - In a saucepan, boil water, sugar, cinnamon stick, and lemon peel strip over medium heat for 4 minutes until it reaches 220°F (105°C) syrup stage. Discard cinnamon and peel.
Step 2: Slurry Thickening - In a separate saucepan, whisk flour with 1/3 cup cold milk until lump-free. Whisk in remaining milk and cream. Cook over medium heat, stirring constantly until thick and bubbling.
Step 3: Marrying Syrup & Base - Pour hot sugar syrup into the thickened milk base in a steady stream, whisking constantly. Let cool for 15 minutes.
Step 4: Whisking in Egg Yolks - Whisk egg yolks into the cooled mixture, then pass through a fine sieve into a pitcher.
Step 5: Shell Shaping - Take a 12-cup metal muffin tin. Place one 1/2-inch pastry slice flat in each cup. Using wet thumbs, press dough from center outward up the sides of each cup, creating a thin shell with a slightly raised rim.
Step 6: Custard Filling - Pour custard into pastry shells, filling each 3/4 full.
Step 7: Maximum-Heat Blister Baking - Bake at your oven''s highest temperature (500°F to 550°F / 260°C to 290°C) on the top rack for 11 to 13 minutes until the puff pastry is deeply browned and flaky, and the custard develops dark caramelized blister spots on top.
Step 8: Cool & Cinnamon Dusting - Cool in pan for 5 minutes, then transfer to a wire rack. Dust with ground Ceylon cinnamon and powdered sugar; serve warm while pastry crackles.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/0/0c/Pasteis_de_Belem.jpg/960px-Pasteis_de_Belem.jpg'),

(69, 7, 'Traditional Sri Lankan Dhal (Parippu) Curry with Coconut Milk & Tempered Spices', 'Vegan', 'Sri Lanka (Traditional Village Hearth Heritage)', 25,
'1.5 cups red split lentils (masoor dhal, rinsed thoroughly until water runs crystal clear)
1 small red onion (thinly sliced)
3 cloves garlic (sliced)
2 green bird''s eye chilies (slit lengthwise)
1 sprig fresh green curry leaves & 2-inch rampe (pandan leaf)
1/2 tsp ground turmeric
1 tsp unroasted raw Sri Lankan curry powder
1/2 tsp fenugreek seeds (uluhal)
1 piece Ceylon cinnamon quill
1.5 cups thin coconut milk (or water) & 3/4 cup thick first-press coconut cream (miti kiri)
Coarse sea salt to taste
For Tempering (Theldala): 1.5 tbsp virgin coconut oil, 1 tsp brown mustard seeds, 1/2 small onion (sliced), 1 sprig curry leaves, 1 tsp crushed dried chili flakes',
'Step 1: Lentil Washing & Cold Clarification - Place red split lentils in a fine colander. Wash repeatedly in cold water for 2-3 minutes, massaging with your fingers until cloudy surface starch washes away completely and water runs clear; drain.
Step 2: Pot Assembly - In a traditional Sri Lankan clay pot (wali athiliya) or heavy saucepan, combine the washed lentils, sliced onions, sliced garlic, slit green chilies, pandan leaf, cinnamon quill, fenugreek seeds, turmeric powder, and unroasted curry powder.
Step 3: Simmering in Thin Coconut Milk - Pour in 1.5 cups thin coconut milk (or water). Bring to a boil over medium heat. Reduce heat to medium-low, cover partially with the clay lid, and simmer gently for 12 to 14 minutes until the lentils absorb the liquid, break down into tender yellow morsels, and soften completely without turning dry.
Step 4: Incorporating Thick First-Press Coconut Cream - Pour in the 3/4 cup rich, thick coconut cream (miti kiri) and season with coarse sea salt. Stir gently with a wooden spoon.
Step 5: Gentle Cream Simmer - Simmer uncovered on low heat for 4-5 minutes until the coconut milk integrates into a silky, luscious, golden-yellow gravy.
Step 6: Executing the Sizzling Tempering (Theldala) - In a separate small iron skillet (thachchiya), heat 1.5 tablespoons coconut oil over high heat. Add brown mustard seeds; let them pop and crackle vigorously for 10 seconds. Immediately add sliced red onions, fresh curry leaves, and crushed chili flakes. Fry for 2 minutes until the onions turn crispy golden-brown and chili flakes sizzle.
Step 7: The Aromatic Sizzle Infusion - Immediately pour the sizzling hot tempering oil and aromatics directly into the bubbling dhal curry with an audible hiss. Cover the pot with its lid for 2 minutes to trap the fragrant roasted allium vapor.
Step 8: Table Presentation - Stir the tempering into the creamy lentils and ladle into ceramic bowls. Serve hot alongside pol roti, string hoppers, or steaming basmati rice.',
'assets/images/recipes/sri-lankan-parippu-curry.jpg'),

(70, 4, 'Creamy Coconut Chickpea & Baby Spinach Curry (Chana Palak Masala)', 'Vegan', 'India (Punjab & North Indian Heritage)', 30,
'2 cans (400g each) cooked chickpeas (garbanzo beans, drained and rinsed)
200g fresh baby spinach leaves (washed and chopped)
2 tbsp cold-pressed mustard oil or coconut oil
1 tsp cumin seeds & 1 black cardamom pod
1 large red onion (finely brunoised)
4 cloves garlic & 1-inch fresh ginger (mortar pounded)
2 ripe plum tomatoes (finely diced)
1 tsp ground turmeric & 1 tbsp Kashmiri chili powder
1 tbsp ground coriander & 1 tsp garam masala
1 cup thick coconut milk
Fresh cilantro and lemon wedges for serving',
'Step 1: Tempering Cumin - Heat oil in a heavy Dutch oven over medium heat. Add cumin seeds and black cardamom; fry for 20 seconds until fragrant.
Step 2: Caramelizing Alliums - Add diced onions and sauté for 6 minutes until sweet and golden brown.
Step 3: Cooking Out Aromatics - Add ginger-garlic paste and fry for 60 seconds until raw smell dissipates.
Step 4: Tomato Masala Base - Stir in diced tomatoes, turmeric, Kashmiri chili powder, coriander, and 1 tsp salt. Cook for 5 minutes, mashing tomatoes until an oily spiced masala sauce forms.
Step 5: Chickpea Infusion - Add rinsed chickpeas and 1/2 cup water. Mash 1/4 of the chickpeas with a potato masher against the pot side (this naturally thickens the sauce without starch). Simmer covered for 10 minutes.
Step 6: Coconut Cream Addition - Pour in thick coconut milk. Simmer uncovered for 5 minutes until rich and creamy.
Step 7: Wilting Baby Spinach - Add fresh baby spinach. Fold into hot curry for 2 minutes until wilted and vibrant emerald green. Stir in garam masala.
Step 8: Service - Squeeze fresh lemon juice over the top, scatter fresh cilantro, and serve hot with basmati rice or roti.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/8/8e/Chana_masala.jpg/960px-Chana_masala.jpg'),

(71, 7, 'Authentic Sri Lankan Polos (Young Green Jackfruit) Tender Curry', 'Vegan', 'Sri Lanka (Kandyan Highlands Heritage)', 60,
'600g fresh young green jackfruit (baby polos, peeled and cut into 1.5-inch chunks)
3 pieces dried Garcinia (Goraka, soaked in warm water and ground to paste)
3 tbsp virgin coconut oil
1 large red onion (sliced), 5 cloves garlic (crushed), 1-inch ginger (crushed)
2 green chilies (slit), 1 sprig curry leaves, 2-inch pandan leaf (rampe)
1 piece Ceylon cinnamon quill & 1 tsp roasted mustard seeds
2.5 tbsp dark roasted Sri Lankan curry powder
1 tbsp roasted chili powder & 1/2 tsp turmeric
2 cups thin coconut milk & 1 cup thick first-press coconut cream
Coarse sea salt to taste',
'Step 1: Polos Prep - Peel tough outer skin of young jackfruit using oiled hands and knife. Cut into 1.5-inch triangular chunks, soaking in water with a pinch of turmeric to prevent discoloration.
Step 2: Spicing in Clay Pot - In an earthenware pot, toss jackfruit chunks with goraka paste, roasted curry powder, roasted chili powder, turmeric, ginger-garlic paste, and coarse salt.
Step 3: Tempering Aromatics - In another pan, heat coconut oil. Sauté onions, green chilies, pandan leaf, cinnamon quill, and curry leaves for 4 minutes until golden.
Step 4: Pot Assembly & Sear - Add sautéed aromatics to the spiced polos pot. Stir-fry over medium-high heat for 3 minutes.
Step 5: The Long Clay Pot Simmer - Pour in thin coconut milk. Bring to a rolling boil, then reduce heat to low, cover with clay lid, and simmer gently for 40 minutes until jackfruit fibers become meltingly tender and absorb the spices like braised meat.
Step 6: First-Press Coconut Cream - Pour in thick coconut cream. Stir gently with a flat wooden spoon.
Step 7: Slow Reduction - Cook uncovered over low heat for 12 minutes until gravy turns dark mahogany brown and spiced coconut oil beads on the surface.
Step 8: Resting - Rest for 20 minutes before serving. Serve with steaming samba rice and coconut sambol.',
'assets/images/recipes/sri-lankan-jackfruit-curry.jpg'),

(72, 9, 'Crispy Golden Tofu & Rainbow Vegetable Wok Stir-Fry with Sesame Ginger Glaze', 'Vegan', 'China (Sichuan & Cantonese Plant-Based Wok Tradition)', 20,
'400g extra-firm organic tofu (pressed dry and cut into 3/4-inch cubes)
2 tbsp cornstarch (for coating tofu)
2 tbsp peanut or toasted sesame oil
1 cup broccoli florets, 1 red bell pepper (sliced), 1 cup sugar snap peas, 1 carrot (sliced into coins)
3 cloves garlic (minced) & 1 tbsp fresh ginger (grated)
For Sesame Ginger Glaze: 3 tbsp low-sodium soy sauce, 1 tbsp rice vinegar, 1 tbsp pure maple syrup, 1 tsp toasted sesame oil, 1 tsp sriracha, 1 tsp cornstarch whisked with 2 tbsp cold water
Toasted sesame seeds & sliced scallions for garnish',
'Step 1: Pressing Tofu - Wrap tofu block in clean kitchen towels. Place a heavy skillet on top for 15 minutes to press out moisture. Cut into 3/4-inch uniform cubes.
Step 2: Cornstarch Dusting - Toss tofu cubes in a bowl with cornstarch until evenly coated in a dry white film.
Step 3: Pan-Searing Tofu - Heat 1.5 tablespoons oil in a heavy non-stick skillet or wok over medium-high heat. Add tofu cubes in a single layer. Sear undisturbed for 3 minutes per side until all six sides are crispy and golden; transfer to a plate.
Step 4: High-Heat Vegetable Wok Sear - Swirl remaining oil in the wok over high heat. Add broccoli, sliced carrots, bell peppers, and snap peas. Stir-fry vigorously for 3 minutes until vibrant and tender-crisp.
Step 5: Aromatics - Add minced garlic and grated ginger; toss for 30 seconds until aromatic.
Step 6: Glaze Thickening - Whisk glaze ingredients and pour around hot wok edges. Toss vegetables as sauce bubbles and thickens into a glossy coat.
Step 7: Tofu Integration - Return crispy tofu cubes to wok; toss for 30 seconds to coat in glaze without losing crunch.
Step 8: Garnish & Service - Plate over steamed Jasmine rice. Scatter toasted sesame seeds and sliced scallions over top.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/e/e7/Crispy_Tofu_-_Stir_Fry_by_CK_2025-04-06.jpg/960px-Crispy_Tofu_-_Stir_Fry_by_CK_2025-04-06.jpg'),

(73, 2, 'Velvety Roasted Butternut Squash Soup with Crispy Fried Sage & Spiced Pepitas', 'Vegan', 'United States (New England Autumn Tradition)', 40,
'1 large butternut squash (approx. 1.2 kg, peeled, seeded, and cut into 1-inch cubes)
1 large sweet yellow onion (wedged)
4 cloves garlic (whole in skins)
3 tbsp extra virgin olive oil
1 tbsp pure Grade-A maple syrup
3.5 cups rich vegetable broth
1/2 cup full-fat coconut milk (for velvety finish)
1/2 tsp ground nutmeg & 1/4 tsp ground cinnamon
12 fresh sage leaves (crisped in olive oil)
1/4 cup roasted salted pepitas (pumpkin seeds)
Flaky sea salt & freshly ground black pepper',
'Step 1: High-Heat Roasting - Toss cubed squash and onion wedges with 2 tbsp olive oil, maple syrup, salt, and pepper. Spread on a parchment-lined baking sheet alongside garlic cloves. Roast at 400°F (200°C) for 30 minutes until edges are caramelized.
Step 2: Garlic Squeeze - Squeeze roasted garlic from skins into a heavy soup pot. Add roasted squash and caramelized onions.
Step 3: Broth Simmer - Pour in vegetable broth. Add ground nutmeg and cinnamon. Bring to a boil, then reduce heat and simmer for 10 minutes.
Step 4: High-Shear Pureeing - Using an immersion stick blender, purée soup on high speed for 2 minutes until velvety and completely smooth.
Step 5: Coconut Cream Finish - Stir in coconut milk. Taste and adjust seasoning with sea salt and cracked pepper; keep warm on low.
Step 6: Crisping Sage Leaves - In a small skillet, heat 1 tablespoon olive oil over medium-high heat. Drop in fresh sage leaves. Fry for 15 seconds until translucent and crisp; transfer to paper towels.
Step 7: Ladling - Ladle hot velvety orange soup into warmed shallow bowls.
Step 8: Garnish - Drizzle a swirl of coconut cream, arrange crispy fried sage leaves, and scatter toasted pepitas over the center.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/6/62/Butternut_squash_soup_%285171665819%29.jpg/960px-Butternut_squash_soup_%285171665819%29.jpg'),

(74, 14, 'Authentic Sri Lankan Spicy Tempered Potatoes (Ala Theldala)', 'Vegan', 'Sri Lanka (Ceylon Comfort & Street Culture)', 25,
'500g firm potatoes (boiled in salted water with turmeric, peeled, and cut into 1-inch chunks)
2.5 tbsp virgin coconut oil
1 tsp brown mustard seeds
1 large red onion (thickly sliced)
3 cloves garlic (sliced)
2 sprigs fresh curry leaves & 2-inch rampe (pandan leaf)
1.5 tbsp crushed dried red chili flakes (kochchi or regular red chili)
1/2 tsp ground turmeric
1/2 tsp ground black pepper
1 tbsp fresh lime juice
Coarse sea salt to taste',
'Step 1: Potato Parboiling - Boil whole unpeeled potatoes in salted water with 1/2 tsp turmeric for 18 minutes until tender to a knife tip. Drain, peel while warm, and cut into 1-inch bite-sized cubes.
Step 2: Mustard Seed Crackle - Heat coconut oil in a wide heavy skillet over medium-high heat. Add mustard seeds; let them pop vigorously for 10 seconds.
Step 3: Sautéing Aromatics - Add sliced red onions, sliced garlic, pandan leaf, and fresh curry leaves. Sauté for 3-4 minutes until onions soften and develop brown edges.
Step 4: Blooming Spices - Lower heat to medium. Add chili flakes, black pepper, turmeric, and sea salt. Stir-fry for 45 seconds to infuse the spicy oils without burning.
Step 5: Searing Potato Cubes - Add the boiled potato cubes. Toss gently with a wooden spatula until every cube is coated in the fiery crimson spice mixture.
Step 6: Developing Crispy Edges - Spread potatoes in a single layer. Cook undisturbed for 3 minutes over medium heat to develop crispy, blistered crusts on the bottom; flip and crisp for 2 minutes more.
Step 7: Lime Juice Finish - Extinguish heat. Squeeze fresh lime juice over the sizzling potatoes and toss once.
Step 8: Service - Serve warm alongside coconut roti, string hoppers, or rice and curry.',
'assets/images/recipes/sri-lankan-eggplant-moju.jpg'),

(75, 26, 'Authentic Creamy Lebanese Hummus with Garlic, Tahini & First-Harvest Olive Oil', 'Vegan', 'Middle East (Levant - Beirut, Lebanon)', 25,
'2 cups dried chickpeas (soaked 12 hours with 1 tsp baking soda, boiled until meltingly tender) or 2 cans high-quality chickpeas
1/2 cup authentic Lebanese pure sesame tahini
1/3 cup freshly squeezed lemon juice (strained)
2 cloves fresh garlic (crushed with salt)
1/3 cup ice-cold water (with ice cubes)
1 tsp fine sea salt & 1/2 tsp ground cumin
3 tbsp cold-pressed extra virgin olive oil
Ground sweet paprika, whole chickpeas, and fresh parsley for garnish',
'Step 1: Overcooking Chickpeas - Simmer drained chickpeas with 1/2 tsp baking soda for 20 minutes until extremely soft and skins slip off easily when rubbed. Drain, reserving a few whole chickpeas for garnish.
Step 2: Pureeing Warm Chickpeas - Place warm chickpeas in a high-powered food processor. Process for 3 full minutes until a smooth, thick purée forms.
Step 3: Emulsifying Tahini & Lemon - In a bowl, whisk tahini, fresh lemon juice, crushed garlic, and salt until it thickens into a pale paste.
Step 4: Blending Together - Add tahini mixture to the food processor with the chickpeas. Process for 2 minutes.
Step 5: Ice Water Aeration Secret - With processor running, slowly pour in ice-cold water in a thin stream. Process for 3 minutes. The ice water emulsifies the sesame oils and chickpea starches, transforming the mixture into an ultra-light, pale, cloud-like silky purée.
Step 6: Seasoning Check - Taste and adjust lemon juice and salt.
Step 7: Swirling Technique - Spoon hummus onto a shallow wide plate. Use the back of a large metal spoon to create a decorative deep spiral well in the center.
Step 8: Garnish & Pita Service - Fill the spiral well with extra virgin olive oil. Garnish with reserved whole chickpeas, sweet paprika, and chopped parsley. Serve with warm pita bread.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/b/bf/Lebanese_style_hummus.jpg/960px-Lebanese_style_hummus.jpg'),

(76, 12, 'Vegan Thai Peanut Rice Noodle Salad with Crispy Edamame & Fresh Herbs', 'Vegan', 'Thailand (Central Thai Street Noodle Tradition)', 20,
'250g Thai brown rice noodles or pad thai rice sticks
1 cup shredded purple cabbage & 1 cup julienned carrots
1 red bell pepper (thinly sliced)
1 cup shelled edamame (steamed)
1/2 cup fresh cilantro & 1/3 cup fresh mint leaves
For Creamy Peanut Lime Dressing: 1/3 cup creamy peanut butter, 2 tbsp tamari / soy sauce, 2 tbsp fresh lime juice, 1.5 tbsp maple syrup, 1 tbsp grated ginger, 1 clove garlic (minced), 1 tsp toasted sesame oil, 3 tbsp warm water
1/3 cup crushed roasted salted peanuts for topping',
'Step 1: Rice Noodle Soaking - Submerge rice noodles in boiling water for 6-8 minutes until tender with a gentle chew. Drain, rinse under cold water, and drain completely.
Step 2: Dressing Emulsion - Whisk peanut butter, soy sauce, lime juice, maple syrup, grated ginger, minced garlic, sesame oil, and warm water until smooth and pourable.
Step 3: Edamame Steaming - Steam shelled edamame for 3 minutes; cool in cold water.
Step 4: Vegetable Slicing - Finely shred red cabbage, carrots, and bell peppers into thin matchsticks.
Step 5: Bowl Tossing - In a large bowl, combine cold noodles, edamame, and sliced vegetables.
Step 6: Dressing Integration - Pour peanut dressing over noodles; toss gently with tongs until evenly coated.
Step 7: Fresh Herbs - Fold in fresh cilantro and torn mint leaves.
Step 8: Garnish & Plating - Mound in bowls and shower with crushed roasted peanuts and a squeeze of fresh lime.',
'assets/images/recipes/thai-peanut-rice-noodle-salad.jpg'),

(77, 6, 'Hearty Vegan Black Bean & Sweet Potato Chili with Cumin & Dark Cocoa', 'Vegan', 'United States (Southwestern / Texas-Mexican Tradition)', 45,
'2 cans (400g each) black beans (drained and rinsed)
2 medium sweet potatoes (peeled and diced into 1/2-inch cubes)
2 tbsp olive oil
1 large red onion & 1 red bell pepper (diced)
4 cloves garlic (minced)
1 can (400g) crushed fire-roasted tomatoes
2 cups vegetable broth
1.5 tbsp chili powder & 1 tbsp ground cumin
1 tsp smoked paprika & 1/2 tsp dried Mexican oregano
1 tbsp unsweetened Dutch cocoa powder (secret Mexican depth ingredient)
Sea salt and black pepper
Diced avocado, fresh cilantro, and lime wedges for serving',
'Step 1: Sautéing Aromatics - Heat olive oil in a Dutch oven over medium heat. Sauté diced onions and bell peppers for 5 minutes until soft.
Step 2: Garlic & Spices - Add minced garlic, chili powder, ground cumin, smoked paprika, and Mexican oregano. Cook for 60 seconds until fragrant.
Step 3: Cocoa Incorporation - Stir in unsweetened cocoa powder; the bitter chocolate harmonizes the chili spices with deep earthy richness.
Step 4: Tomatoes & Broth - Add crushed fire-roasted tomatoes and vegetable broth, stirring to scrape up fond.
Step 5: Sweet Potatoes & Beans - Add diced sweet potatoes and rinsed black beans. Season with 1.5 tsp salt and cracked black pepper.
Step 6: Simmering - Bring to a boil, reduce heat to low, cover, and simmer for 25 minutes until sweet potatoes are fork-tender.
Step 7: Thickening - Remove lid. Mash 1 cup of the chili against the pot side to thicken the sauce naturally; simmer uncovered for 5 minutes.
Step 8: Service - Ladle into bowls. Top with diced avocado, fresh cilantro leaves, and a squeeze of lime.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/5/50/Bowl_of_chili.jpg/960px-Bowl_of_chili.jpg'),

(78, 7, 'Authentic Sri Lankan Gotu Kola Sambol (Pennywort Herb & Fresh Coconut Salad)', 'Vegan', 'Sri Lanka (Ayurvedic Herbal Heritage)', 15,
'2 large bunches fresh Gotu Kola (Asiatic Pennywort, washed thoroughly and spun bone-dry)
1 cup freshly scraped coconut (freshly grated pol)
6 red shallots (finely minced)
2 green bird''s eye chilies (finely sliced into micro-rounds)
1 small ripe tomato (finely diced, seeds removed)
1.5 tbsp freshly squeezed lime juice
1/2 tsp ground black pepper
1/2 tsp fine sea salt',
'Step 1: Herb Cleaning - Wash gotu kola stems and leaves thoroughly in cold water to remove soil. Spin completely dry in a salad spinner. Dampness makes the herb wilt prematurely.
Step 2: Fine Chiffonade Shredding - Gather gotu kola stems and leaves into a tight cylindrical bundle on a wooden board. Using a razor-sharp chef''s knife, slice very finely across the bundle into micro-thin ribbons. Place shredded herbs in a clean bowl.
Step 3: Pre-Mixing Scraped Coconut & Aromatics - In a separate small bowl, combine freshly scraped coconut, minced red shallots, sliced green chilies, diced tomato, salt, and black pepper.
Step 4: Rubbing the Aromatics - Use your clean fingers to gently massage the shallots, chilies, and coconut together for 30 seconds to release natural coconut oils and allium juices.
Step 5: Gentle Incorporation - Add the coconut-shallot mixture to the shredded gotu kola.
Step 6: Lime Juice Dressing - Squeeze fresh lime juice over the ingredients.
Step 7: The Light Finger Toss - Toss delicately with fingers just until evenly combined. Never over-toss or squeeze hard, which bruises the delicate gotu kola leaves.
Step 8: Fresh Table Service - Serve immediately alongside warm rice and dhal curry. Enjoy fresh to savor the crisp herbal crunch and rich Ayurvedic nutrients.',
'assets/images/recipes/sri-lankan-pol-sambol.jpg'),

(79, 26, 'Loaded Mediterranean Quinoa Harvest Bowl with Crispy Chickpeas & Lemon Tahini', 'Vegan', 'Greece & Levant (Modern Mediterranean Cuisine)', 25,
'1.5 cups cooked white and red quinoa (fluffed and cooled)
1 can (400g) chickpeas (tossed with 1 tbsp olive oil, cumin, smoked paprika, and roasted crispy at 400°F for 20 mins)
1 cup Persian cucumbers (diced)
1 cup cherry tomatoes (halved)
1/2 cup Kalamata olives (pitted and sliced)
1 ripe avocado (sliced)
1/4 cup pickled red onions
For Lemon Tahini Dressing: 1/4 cup pure sesame tahini, 3 tbsp warm water, 2 tbsp fresh lemon juice, 1 clove garlic (grated), 1/2 tsp salt',
'Step 1: Quinoa Cooking - Simmer rinsed quinoa in 2 cups salted water for 15 minutes; remove from heat, let steam covered 5 minutes, and fluff with a fork.
Step 2: Roasting Crispy Chickpeas - Toss drained chickpeas with olive oil, cumin, paprika, and salt. Roast at 400°F (200°C) for 20 minutes until crunchy and golden.
Step 3: Whipping Tahini - Whisk tahini, lemon juice, grated garlic, salt, and warm water in a ramekin until creamy and smooth.
Step 4: Vegetable Slicing - Halve cherry tomatoes, dice Persian cucumbers, and slice Kalamata olives.
Step 5: Base Foundation - Divide fluffy quinoa across wide shallow bowls.
Step 6: Arranging Harvest Components - Arrange toppings in sections over the quinoa: roasted crispy chickpeas, diced cucumbers, halved tomatoes, olives, and sliced avocado.
Step 7: Pickled Onions - Top with vibrant pink pickled red onions.
Step 8: Dressing & Service - Drizzle generous ribbons of lemon tahini dressing across the bowl and serve immediately.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/6/64/Healthy_quinoa_salad_with_dried_fruit.jpg/960px-Healthy_quinoa_salad_with_dried_fruit.jpg'),

(80, 11, 'Creamy Vegan Avocado Basil Pesto Pasta with Blistered Cherry Tomatoes', 'Vegan', 'Italy (Ligurian Pesto Reimagined)', 20,
'350g bronze-die extruded Penne Rigate or Fusilli pasta
2 ripe Hass avocados (peeled and pitted)
2 packed cups fresh Genovese basil leaves
1/3 cup toasted pine nuts (or walnuts)
3 tbsp nutritional yeast (for rich savory cheese flavor)
2 cloves garlic
3 tbsp fresh lemon juice
1/3 cup cold-pressed extra virgin olive oil
200g sweet cherry tomatoes (blistered in olive oil)
Coarse sea salt & freshly cracked black pepper',
'Step 1: Pasta Cooking - Cook pasta in 4 quarts of salted boiling water until strictly al dente. Reserve 1/2 cup starchy pasta water; drain pasta.
Step 2: Processing Pesto - In a food processor, combine avocados, fresh basil leaves, toasted pine nuts, nutritional yeast, garlic cloves, lemon juice, 1/2 tsp salt, and olive oil.
Step 3: Pureeing - Blend for 90 seconds until a brilliant green, velvety, silky cream forms.
Step 4: Blistering Tomatoes - In a skillet with 1 tbsp olive oil over high heat, blister cherry tomatoes for 3 minutes until skins burst and char lightly.
Step 5: Marrying Sauce & Pasta - Place drained warm pasta in a large bowl. Add avocado pesto.
Step 6: Starch Water Emulsion - Splash in 3-4 tablespoons of reserved warm pasta water. Toss gently with tongs until every pasta tube is enveloped in the glossy green pesto.
Step 7: Fold Blistered Tomatoes - Gently fold in blistered sweet cherry tomatoes.
Step 8: Service - Plate in wide pasta bowls, garnish with fresh basil leaves and toasted pine nuts, and serve immediately.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/5/59/Flickr_-_cyclonebill_-_Penne_med_pesto%2C_cherrytomater%2C_sorte_oliven_og_gedeost.jpg/960px-Flickr_-_cyclonebill_-_Penne_med_pesto%2C_cherrytomater%2C_sorte_oliven_og_gedeost.jpg'),

(81, 7, 'Authentic Sri Lankan Tempered Okra (Bandakka Theldala) with Onions & Chili', 'Vegan', 'Sri Lanka (Southern Province, Galle)', 20,
'400g fresh tender green okra (bandakka, washed, dried thoroughly, and sliced 1/2-inch thick on a bias)
2 tbsp virgin coconut oil
1 tsp brown mustard seeds
1 large red onion (thinly sliced)
3 cloves garlic (sliced)
1 sprig fresh curry leaves & 2-inch rampe (pandan leaf)
1 tbsp crushed dried red chili flakes
1/2 tsp ground turmeric
1/2 tsp crushed black pepper
1 tbsp lime juice
Coarse sea salt to taste',
'Step 1: Desiccating Okra (Zero Slime Technique) - Wash whole okra pods and dry thoroughly with a towel. Moisture causes slime! Slice okra into 1/2-inch diagonal coins on a dry board.
Step 2: Mustard Pop - Heat coconut oil in a wide heavy skillet over medium-high heat. Add mustard seeds; let pop for 10 seconds.
Step 3: Aromatics - Add sliced red onions, garlic, pandan leaf, and curry leaves. Sauté for 3 minutes until onions turn light golden.
Step 4: Dry Okra Searing - Add sliced okra to the skillet in an uncrowded single layer. Cook over medium-high heat undisturbed for 3 minutes.
Step 5: Toss & Evaporate - Toss okra and continue stir-frying for 4 minutes. The high dry heat evaporates any mucilage, leaving the okra tender-crisp.
Step 6: Seasoning - Add crushed chili flakes, turmeric, black pepper, and coarse sea salt. Toss for 2 minutes to toast the spices onto the okra.
Step 7: Lime Squeeze - Remove from heat and drizzle with fresh lime juice.
Step 8: Table Service - Serve immediately alongside steaming rice, dhal, and coconut sambol.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/4/4d/Baigan_Bharta_from_Nagpur.JPG/960px-Baigan_Bharta_from_Nagpur.JPG'),

(82, 17, 'Crispy Oven-Baked Cauliflower Buffalo Wings with Tangy Garlic Herb Dip', 'Vegan', 'United States (Buffalo, New York Tradition)', 35,
'1 large head fresh cauliflower (cut into bite-sized ''wing'' florets)
For Crispy Batter: 3/4 cup all-purpose flour, 1 tsp garlic powder, 1 tsp onion powder, 1 tsp smoked paprika, 1/2 tsp salt, 3/4 cup water or unsweetened plant milk
1.5 cups panko breadcrumbs
For Buffalo Glaze: 1/2 cup Frank''s RedHot original cayenne pepper sauce, 3 tbsp melted coconut oil or vegan butter, 1 tbsp pure maple syrup
Celery sticks & vegan ranch dip for serving',
'Step 1: Floret Cutting - Cut cauliflower into bite-sized wing florets with short stems. Wash and dry.
Step 2: Batter Whisking - In a bowl, whisk flour, garlic powder, onion powder, smoked paprika, salt, and water until a smooth, pourable pancake-like batter forms.
Step 3: Breading Station - Dip cauliflower florets into batter, let excess drip off, then roll thoroughly in panko breadcrumbs.
Step 4: Parchment Layout - Arrange breaded florets on a parchment-lined baking sheet with 1 inch space between each.
Step 5: First Bake - Bake at 450°F (230°C) for 20 minutes until golden and crispy.
Step 6: Buffalo Glaze Whisk - In a bowl, whisk Frank''s RedHot sauce, melted vegan butter, and maple syrup.
Step 7: Glaze Coating & Second Bake - Dip baked crispy florets into the Buffalo glaze to coat, return to the baking sheet, and bake for 8 minutes more until glaze is bubbly and caramelized.
Step 8: Service - Serve immediately with crisp celery sticks and chilled vegan garlic ranch dip.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/5/52/Hotforfoodblogcauliflowerbuffalowingsimage.jpg/960px-Hotforfoodblogcauliflowerbuffalowingsimage.jpg'),

(83, 20, 'Rich Vegan Dark Chocolate Avocado Mousse with Fresh Raspberries', 'Vegan', 'France (Modern Plant-Based Haute Cuisine)', 15,
'2 ripe Hass avocados (soft to gentle pressure, peeled and pitted)
100g premium dark chocolate (70% cacao, melted and cooled)
1/2 cup Dutch-process cocoa powder (sifted)
1/2 cup pure Grade-A maple syrup
1/3 cup full-fat coconut milk (or almond milk)
1.5 tsp pure vanilla extract
1/4 tsp fine sea salt
Fresh raspberries, dark chocolate shavings, and fresh mint sprigs for garnish',
'Step 1: Melting Chocolate - Melt chopped 70% dark chocolate in a heatproof bowl over a pan of barely simmering water; let cool to lukewarm.
Step 2: Food Processor Setup - Place pitted ripe avocado flesh into a high-speed food processor.
Step 3: Adding Ingredients - Add melted chocolate, sifted cocoa powder, maple syrup, coconut milk, vanilla extract, and sea salt.
Step 4: High-Shear Blending - Process on high speed for 2.5 minutes, stopping halfway to scrape down the sides with a spatula, until the mixture transforms into a mirror-smooth, glossy, rich dark chocolate mousse.
Step 5: Glass Portions - Spoon or pipe mousse into four elegant dessert glasses or coupe dishes.
Step 6: Chilling - Refrigerate for at least 1 hour to set and allow the avocado flavor to disappear completely into rich chocolate indulgence.
Step 7: Garnish - Top each glass with fresh wild raspberries, shaved dark chocolate flakes, and a sprig of mint.
Step 8: Service - Serve chilled with small dessert spoons.',
'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Chocolate_mousse_%2816013444604%29.jpg/960px-Chocolate_mousse_%2816013444604%29.jpg'),

(84, 7, 'Authentic Sri Lankan Royal Cashew Nut Curry (Kaju Maluwa) with Green Peas', 'Vegan', 'Sri Lanka (Royal Festive & Wedding Banquet Heritage)', 35,
'350g raw whole cashew nuts (soaked in boiling water for 3 hours until plump and soft)
1 cup sweet garden green peas
2 tbsp virgin coconut oil
1 medium red shallot or onion (thinly sliced)
3 cloves garlic & 1-inch ginger (finely crushed)
2 green bird''s eye chilies (slit lengthwise)
1 sprig fresh curry leaves & 2-inch rampe (pandan leaf)
1 piece Ceylon cinnamon quill & 3 green cardamom pods
1 tsp unroasted raw Sri Lankan curry powder
1/2 tsp ground turmeric
1/2 tsp fenugreek seeds (uluhal)
1.5 cups thin coconut milk & 3/4 cup thick first-press coconut cream (miti kiri)
Coarse sea salt to taste',
'Step 1: Rehydrating Raw Cashews - Place raw cashew nuts in a bowl, pour boiling water over them, and let soak for 3 hours until plump, tender, and pale ivory in color; drain.
Step 2: Clay Pot Tempering - Heat coconut oil in an earthenware pot (chatti) over medium heat. Add fenugreek seeds, cardamoms, cinnamon quill, pandan leaf, and fresh curry leaves. Sauté for 1 minute until fragrant.
Step 3: Aromatics - Add sliced red shallots, green chilies, and ginger-garlic paste. Sauté for 4 minutes until onions are translucent and fragrant.
Step 4: Cashew Introduction - Add the drained plump cashews into the pot. Sauté for 2 minutes with turmeric, unroasted curry powder, and sea salt to coat evenly.
Step 5: Thin Coconut Milk Simmer - Pour in 1.5 cups thin coconut milk. Bring to a boil, then reduce heat to low, cover with the clay lid, and simmer gently for 15 minutes until cashews are tender and creamy to the bite.
Step 6: Green Peas & First-Press Cream - Add green peas and pour in 3/4 cup thick first-press coconut cream (miti kiri). Stir gently.
Step 7: Gravy Reduction - Simmer uncovered on low heat for 5-7 minutes until the gravy thickens to a luxurious, pale-golden, mild creamy sauce.
Step 8: Royal Service - Rest for 10 minutes. Serve hot as the centerpiece of a traditional Sri Lankan rice and curry spread.',
'https://thumb.wikimedia.org/wikipedia/commons/thumb/9/9f/Navratan_korma_picture.JPG/960px-Navratan_korma_picture.JPG'),

(85, 4, 'Traditional Ceylon Spiced Milk Tea (Masala Chai) with Fresh Ginger & Cardamom', 'Beverages', 'Sri Lanka & India (Ceylon Tea Plantation Heritage)', 15,
'3 tbsp premium Ceylon BOPF black tea leaves (high-grown Nuwara Eliya or Dimbula)
2 cups filtered water & 2 cups rich whole milk
1.5-inch fresh ginger root (peeled and crushed in a mortar)
5 green cardamom pods (cracked open)
1 piece Ceylon cinnamon quill (crushed)
3 whole cloves & 4 black peppercorns
2.5 tbsp raw cane sugar or jaggery',
'Step 1: Crushing the Whole Spices - In a stone mortar, crush the green cardamom pods, cloves, cinnamon quill, and black peppercorns with the pestle until coarse fragments form. Add fresh ginger and pound into a juicy paste.
Step 2: Water Decoction Boiling - In a heavy saucepan, combine 2 cups water with the crushed spices and ginger. Bring to a rolling boil over medium-high heat. Simmer for 3 minutes to extract the potent essential oils and pungent gingerol.
Step 3: Brewing Ceylon Black Tea - Add Ceylon black tea leaves. Boil vigorously for 2 minutes until the liquid turns dark amber-ruby and intensely fragrant.
Step 4: Milk Integration - Pour in whole milk. Stir in raw cane sugar or shaved jaggery.
Step 5: The Triple Boil-Rise Technique - Watch the pot closely as it heats over medium-high. As the milk reaches boiling point, it will froth and rise rapidly toward the rim. Lower heat just in time to let it subside. Repeat this boil-and-fall cycle 3 times; this traditional technique caramelizes milk sugars and creates rich, creamy micro-foam.
Step 6: Straining - Remove from heat. Pour the spiced chai through a fine-mesh tea strainer into a heatproof pitcher, pressing the tea leaves with the back of a spoon to extract every drop of concentrated flavor.
Step 7: The Aeration Pull (Meter-Long Pour) - Hold the pitcher high above two ceramic cups or clay kulhars and pour in a long, continuous arcing stream back and forth twice. Aerating cools the tea slightly and builds a thick, frothy head of foam.
Step 8: Service - Serve piping hot alongside savory biscuits, samosas, or traditional milk toffee.',
'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/Bubble_tea_by_Johnny.jpg/960px-Bubble_tea_by_Johnny.jpg'),

(86, 2, 'Tropical Mango Passion Fruit Smoothie with Chia Seeds & Mint', 'Beverages', 'Brazil & Tropical Americas', 10,
'2 ripe sweet tropical mangoes (peeled and cubed, frozen for 2 hours)
Pulp of 3 fresh purple passion fruits (seeds included)
1 cup fresh coconut water (from young coconut)
1/2 cup Greek yogurt or coconut yogurt
1 tbsp raw wild honey
1 tbsp chia seeds (soaked in 3 tbsp water for 10 mins)
Fresh mint sprigs and passion fruit halves for garnish',
'Step 1: Fruit Freezing - Freeze diced ripe mango cubes for 2 hours. Using frozen fruit provides a thick, frosty texture without diluting flavors with ice cubes.
Step 2: Passion Fruit Pulp Extraction - Halve fresh passion fruits with a sharp knife. Scoop the fragrant, tangy pulp and crunchy seeds into a small glass bowl.
Step 3: Chia Seed Hydration - In a small ramekin, soak chia seeds in water for 10 minutes until a gelatinous nutrient-dense gel forms.
Step 4: Blender Assembly - In a high-speed blender, combine the frozen mango cubes, half of the passion fruit pulp, fresh coconut water, yogurt, and wild honey.
Step 5: High-Shear Pureeing - Blend on high speed for 60 to 90 seconds until completely silky, thick, and vibrant sunshine-orange.
Step 6: Chia Glass Layering - Spoon the hydrated chia seed gel into the bottom of two chilled tall glass tumblers.
Step 7: Smoothie Pour - Pour the thick mango smoothie into each glass over the chia seed layer.
Step 8: Garnish & Service - Spoon the remaining fresh passion fruit pulp across the top. Garnish with a sprig of fresh mint and serve with a glass straw.',
'assets/images/recipes/mango-passion-fruit-smoothie.jpg'),

(87, 7, 'Authentic Sri Lankan Street Faluda with Rose Syrup, Basil Seeds & Ice Cream', 'Beverages', 'Sri Lanka (Colombo Street & Muslim Festive Heritage)', 15,
'3 cups rich whole milk (chilled until nearly freezing)
1/2 cup authentic rose syrup (Sherbet syrup / Rooh Afza)
2 tbsp Kasakasa (sweet basil seeds / sabja seeds, soaked in cold water for 15 mins)
1/2 cup prepared red rose jelly (agar-agar, cut into tiny cubes)
1/2 cup cooked falooda cornstarch vermicelli noodles (chilled)
2 scoops premium rich vanilla bean ice cream
1 tbsp crushed toasted pistachios and cashews for topping',
'Step 1: Basil Seed Bloom - Soak sweet basil seeds (kasakasa) in 1 cup cold water for 15 minutes. The tiny black seeds will hydrate dramatically, developing a soft translucent gelatinous halo.
Step 2: Agar-Agar Jelly Cubing - Prepare rose-flavored agar-agar jelly, let set firm in the refrigerator, and cut into tiny 1/4-inch jewel-like cubes.
Step 3: Rose Milk Emulsion - In a pitcher, whisk chilled whole milk with 4 tablespoons of rose syrup until sweet, fragrant, and a vibrant pastel pink.
Step 4: Base Layering - Take two tall, chilled milkshake parfait glasses. Drizzle 1 tablespoon of thick pure rose syrup along the inside glass walls for decorative ribbons.
Step 5: Texture Tier - Drop 2 tablespoons of soaked basil seeds into the bottom of each glass. Add 2 tablespoons of rose jelly cubes and a small nest of cold vermicelli noodles.
Step 6: Rose Milk Pour - Slowly pour the ice-cold rose milk over the layered ingredients until the glass is three-quarters full.
Step 7: Ice Cream Summit - Gently crown each glass with a generous, perfectly spherical scoop of rich vanilla bean ice cream resting on the surface.
Step 8: Garnish & Service - Drizzle a few drops of red rose syrup over the ice cream scoop and scatter with crushed pistachios. Serve immediately with a long soda spoon and wide straw.',
'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/Horchata_de_arroz.jpg/960px-Horchata_de_arroz.jpg'),

(88, 26, 'Refreshing Middle Eastern Mint Lemonade (Limonana) with Crushed Ice', 'Beverages', 'Middle East (Levant - Tel Aviv & Beirut, 1990s)', 10,
'1 cup freshly squeezed Meyer lemon juice (approx. 5-6 lemons, strained)
1.5 packed cups fresh spearmint leaves (washed, stems removed)
1/2 cup cane sugar syrup (simple syrup made from equal parts sugar and water)
3 cups ice cubes
1/2 cup cold sparkling or still water
Fresh lemon wheels & mint sprigs for garnish',
'Step 1: Fresh Lemon Juicing - Squeeze fresh lemons until you have 1 cup of juice. Strain through a fine-mesh sieve to remove seeds and excess pulp.
Step 2: Simple Syrup Cooling - Dissolve cane sugar into boiling water in equal parts; cool completely in the refrigerator.
Step 3: Mint Selection - Pluck fresh, bright green spearmint leaves from their stems. Stems impart bitterness; only tender leaves should be used.
Step 4: High-Power Blender Loading - Add strained lemon juice, cooled simple syrup, fresh mint leaves, and cold water to a high-speed blender.
Step 5: Ice Loading - Add the 3 cups of solid ice cubes on top of the liquid.
Step 6: Blending to Frozen Slush - Pulse on high speed for 30 to 45 seconds until the ice is crushed into an ultra-fine, frosty green snow slush with flecks of emerald mint suspended evenly throughout.
Step 7: Frosting the Glass - Dip rims of highball glasses in lemon juice, then in sugar.
Step 8: Garnish & Service - Pour the frosty green Limonana into chilled glasses. Garnish with a fresh lemon wheel on the rim and a sprig of mint. Serve immediately while frosty.',
'https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Mint_lemonade.jpg/960px-Mint_lemonade.jpg'),

(89, 24, 'Ceremonial Iced Matcha Green Tea Latte with Creamy Oat Milk', 'Beverages', 'Japan (Uji, Kyoto Heritage)', 10,
'2 tsp ceremonial grade Uji Matcha powder (first harvest, vibrant emerald green)
1/4 cup hot filtered water (strictly 175°F / 80°C, never boiling)
1 cup barista-edition creamy oat milk (or whole milk)
1 tbsp pure agave nectar or vanilla syrup
1 cup solid clear ice cubes',
'Step 1: Water Temperature Calibration - Heat filtered water to exactly 175°F (80°C). Boiling water scorches delicate catechins in matcha, producing unpleasant bitterness.
Step 2: Sifting Matcha - Sift ceremonial matcha powder through a fine-mesh tea sieve into a wide ceramic tea bowl (chawan) to eliminate all static clumps.
Step 3: Bamboo Whisk Conditioning - Soften the tines of a traditional bamboo whisk (chasen) in warm water for 60 seconds.
Step 4: Whisking the Emerald Crema - Pour the hot water into the matcha. Whisk vigorously in a rapid ''W'' or ''M'' motion using your wrist (not your arm) for 30 seconds until the powder is fully dissolved and a dense, velvety micro-foam of tiny jade bubbles forms on top.
Step 5: Glass Prep - In a tall clear glass, add agave nectar or vanilla syrup, then pour in chilled oat milk. Stir to dissolve sweetener.
Step 6: Ice Stacking - Fill the glass to the brim with clear ice cubes.
Step 7: The Slow Floating Layer - Hold a spoon upside down just above the surface of the ice and milk. Slowly pour the warm whisked matcha over the back of the spoon. The density difference between milk and tea creates a stunning, sharp two-toned ombre layer (creamy white base and vibrant jade green top).
Step 8: Service - Serve with a glass straw to stir and enjoy.',
'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Matcha_Latte_KF.JPG/960px-Matcha_Latte_KF.JPG'),

(90, 25, 'Classic Spanish Sangria Mocktail with Fresh Citrus, Berries & Cinnamon', 'Beverages', 'Spain (Andalusia & Madrid Heritage)', 15,
'3 cups 100% pure unsweetened pomegranate or Concord grape juice
1 cup freshly squeezed orange juice
1/4 cup fresh lemon juice
1 Honeycrisp apple (cored and diced)
1 Valencia orange & 1 lemon (sliced into thin wheels)
1 cup fresh blackberries and strawberries (halved)
1 Ceylon cinnamon stick & 2 whole star anise
1.5 cups sparkling water or citrus club soda (chilled)
Fresh mint leaves and ice for serving',
'Step 1: Fruit Slicing - Slice oranges, lemons, and apples into uniform thin wheels and bite-sized cubes. Halve fresh strawberries.
Step 2: Fruit Maceration - Place sliced fruit into a large glass pitcher. Add the cinnamon stick and star anise. Drizzle with 2 tbsp honey and gently muddle with a wooden spoon for 30 seconds to release natural citrus oils from the rinds.
Step 3: Juice Foundation - Pour in dark pomegranate juice, freshly squeezed orange juice, and lemon juice. Stir well with a long bar spoon.
Step 4: Cold Steeping - Cover pitcher and refrigerate for at least 2 hours (or overnight) so the fruit extracts marry with the spiced juice.
Step 5: Pitcher Ice Loading - Just before serving, fill the pitcher with large ice cubes.
Step 6: Sparkling Effervescence - Pour in chilled sparkling water or citrus soda right at the table to create a vibrant, dancing effervescence.
Step 7: Glass Pouring - Fill wine glasses with ice. Pour the sparkling sangria into glasses, spooning marinated fruit pieces into each serving.
Step 8: Garnish - Top with a sprig of bruised fresh mint and a cinnamon stick stirrer.',
'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Red_Wine_Sangria_with_lemon%2C_lime%2C_apple%2C_and_orange_served_in_a_glass_-_Evan_Swigart.jpg/960px-Red_Wine_Sangria_with_lemon%2C_lime%2C_apple%2C_and_orange_served_in_a_glass_-_Evan_Swigart.jpg'),

(91, 4, 'Authentic Sweet Punjabi Mango Lassi with Cardamom, Saffron & Pistachios', 'Beverages', 'India (Punjab - Amritsar Heritage)', 10,
'2 cups ripe sweet Alphonso or Kesar mango pulp (fresh or premium canned)
2 cups thick whole-milk plain Indian dahi (curd / Greek yogurt)
1/2 cup cold whole milk or crushed ice
3 tbsp granulated sugar (adjust based on mango sweetness)
1/2 tsp freshly ground green cardamom powder
1 pinch saffron threads (steeped in 1 tbsp warm milk for 10 mins)
1 tbsp crushed pistachios and sliced almonds for garnish',
'Step 1: Saffron Steeping - Steep saffron threads in 1 tablespoon of warm milk for 10 minutes until liquid turns deep golden-yellow.
Step 2: Ingredients in Blender - In a heavy-duty blender jar, combine thick plain yogurt, Alphonso mango pulp, steeped saffron milk, granulated sugar, and ground cardamom.
Step 3: Splash of Milk - Add 1/2 cup cold milk or crushed ice.
Step 4: High-Speed Emulsion - Blend on high speed for 60 to 75 seconds until velvety smooth, thick, and crowned with tiny micro-bubbles on top.
Step 5: Thickness Check - Check consistency: authentic Punjabi lassi is thick, creamy, and coats a spoon (not watery).
Step 6: Glass Pour - Pour into two chilled clay kulhars or heavy glass tumblers.
Step 7: Garnish - Drop a pinch of crushed green cardamom, chopped raw pistachios, and slivered almonds over the frothy surface.
Step 8: Service - Serve ice-cold alongside spicy Indian dishes or as a refreshing standalone treat.',
'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Mango_lassi_at_restaurant_Momo_%26_More_in_March_2024.jpg/960px-Mango_lassi_at_restaurant_Momo_%26_More_in_March_2024.jpg'),

(92, 17, 'Creamy Caramel Iced Frappuccino with Whipped Cream & Toffee Drizzle', 'Beverages', 'United States (Modern Café Culture)', 10,
'1 cup double-strength brewed dark roast coffee or 2 shots espresso (cooled completely)
3/4 cup cold whole milk
3 tbsp rich caramel syrup
2 cups solid ice cubes
1/4 tsp xanthan gum (secret café emulsion stabilizer for smooth, non-separating frappe)
For Whipped Cream Crown: 1/2 cup heavy whipping cream (whipped to stiff peaks with 1 tbsp powdered sugar)
Rich caramel sauce & crushed toffee bits for topping',
'Step 1: Coffee Chilling - Brew double-strength dark roast coffee and chill completely in the refrigerator.
Step 2: Blender Assembly - In a blender pitcher, combine cold coffee, whole milk, caramel syrup, and xanthan gum (xanthan binds ice crystals and dairy into a silky frozen milkshake consistency with zero separation).
Step 3: Ice Loading - Add the 2 cups of ice cubes.
Step 4: Crushing & Blending - Blend on low speed for 15 seconds to crush ice, then increase to high speed for 45 seconds until thick, creamy, and uniform.
Step 5: Glass Ribbons - Drizzle caramel sauce in swirls inside two tall chilled glasses.
Step 6: Pouring Frappuccino - Pour the thick caramel frappe into the glasses, leaving 1 inch of headspace at the top.
Step 7: Whipped Cream Piping - Pipe a tall, billowy spiral swirl of sweetened whipped cream over each glass.
Step 8: Toffee Garnish - Drizzle caramel sauce over the whipped cream and finish with crunchy toffee bits.',
'https://upload.wikimedia.org/wikipedia/commons/0/09/Starbucks_caramel_flan_frappuccino.jpg'),

(93, 7, 'Sri Lankan King Coconut (Thambili) Lime & Fresh Mint Cooler', 'Beverages', 'Sri Lanka (Indigenous Golden King Coconut)', 5,
'2 fresh Sri Lankan King Coconuts (Thambili, freshly lopped and water poured, approx. 3 cups)
Soft gelatinous tender king coconut meat (scraped with coconut shell horn)
2 tbsp freshly squeezed lime juice
1 tbsp pure wild bee honey (or kithul treacle)
1 pinch Himalayan pink salt or sea salt (balances natural electrolytes)
8 fresh mint leaves (bruised)
Ice cubes and lime slices for serving',
'Step 1: Thambili Water Extraction - Crack open fresh golden King Coconuts. Pour the pure electrolyte-rich water through a fine strainer into a glass pitcher.
Step 2: Scraping Tender Flesh - Using the curved tip of the coconut husk or a spoon, gently scrape the translucent, tender jelly meat from inside the shell; chop into bite-sized silky pieces.
Step 3: Lime & Honey Whisk - Whisk fresh lime juice, wild bee honey, and a pinch of salt into the king coconut water until dissolved.
Step 4: Mint Bruising - Lightly slap fresh mint leaves between your palms to rupture essential oil glands, then drop into the pitcher.
Step 5: Meat Integration - Stir the tender king coconut meat pieces into the liquid.
Step 6: Chilling - Chill in the refrigerator for 20 minutes.
Step 7: Glass Pouring - Fill tall glasses with ice cubes and thin lime wheels. Pour the cold Thambili cooler over the ice, ensuring tender jelly pieces go into each glass.
Step 8: Service - Serve with a bamboo straw on a tropical warm day.',
'assets/images/recipes/brazilian-limonada-suica.jpg'),

(94, 1, 'Creamy Strawberry Banana Milkshake with Vanilla Bean Gelato', 'Beverages', 'United States (Classic 1950s American Diner)', 10,
'2 cups fresh ripe strawberries (hulled and sliced)
1 ripe banana (sliced and frozen)
3 large scoops premium vanilla bean gelato or ice cream
1/2 cup cold whole milk
1 tbsp strawberry jam (for concentrated fruit depth)
Whipped cream, fresh strawberry fan, and Maraschino cherry for topping',
'Step 1: Fruit Prep - Hull fresh strawberries. Freeze sliced banana for 1 hour for thick milkshake body.
Step 2: Blender Loading - Add sliced strawberries, frozen banana slices, vanilla bean gelato, whole milk, and strawberry jam into blender.
Step 3: High-Shear Blending - Blend on medium-high speed for 45 seconds until thick, velvety, and pastel pink.
Step 4: Consistency Check - Shake blender pitcher if necessary. The shake should be thick enough that a spoon stands upright in it.
Step 5: Glass Prep - Drizzle strawberry syrup down the sides of a vintage tall milkshake glass.
Step 6: Pouring - Pour thick shake into the glass.
Step 7: Whipped Cream Crown - Pipe a towering crest of fresh whipped cream over the top.
Step 8: Garnish - Place a fresh sliced strawberry fan and a bright red cherry on top; serve with a retro striped straw.',
'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Strawberry_Milkshake_-_Acme_Cafe_in_Vancouver.jpg/960px-Strawberry_Milkshake_-_Acme_Cafe_in_Vancouver.jpg'),

(95, 2, 'Traditional Mulled Hot Spiced Apple Cider with Cinnamon Quills & Cloves', 'Beverages', 'United States (New England Autumn Orchard Heritage)', 25,
'4 cups pure unfiltered fresh-pressed apple cider
1 Valencia orange (sliced into thick rounds and studded with 12 whole cloves)
3 whole Ceylon cinnamon quills
3 whole star anise pods
1/2 tsp whole allspice berries
1-inch piece fresh ginger (sliced)
2 tbsp pure maple syrup or brown sugar
Cinnamon sticks for mug stirrers',
'Step 1: Cider Selection - Use cloudy, unfiltered fresh-pressed apple orchard cider (not clear filtered apple juice).
Step 2: Clove Studding - Press whole cloves firmly into the rind of orange slices; this keeps cloves contained for effortless serving.
Step 3: Pot Assembly - In a heavy stainless-steel saucepan or slow cooker, combine apple cider, clove-studded orange wheels, cinnamon sticks, star anise pods, allspice berries, and sliced ginger.
Step 4: Sweetener - Stir in pure maple syrup.
Step 5: Gentle Bare Simmer - Heat over medium heat until steaming, then lower heat to low. Cover and simmer gently for 20 minutes (never boil, which destroys fresh orchard fruit aromatics).
Step 6: Flavor Steeping - Turn off heat and let steep covered for 10 minutes to allow spices to infuse deeply into the cider.
Step 7: Straining - Ladle cider through a fine-mesh strainer into heatproof glass mugs.
Step 8: Garnish - Float an orange slice and star anise pod in each mug, drop in a cinnamon quill stirrer, and serve piping hot.',
'https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Cider_and_apple_juice.jpg/960px-Cider_and_apple_juice.jpg'),

(96, 6, 'Fresh Watermelon Basil Sparkler with Crushed Ice & Meyer Lime', 'Beverages', 'Mexico (Agua Fresca Tradition)', 10,
'4 cups seedless ripe red watermelon (cubed and chilled)
1/4 cup fresh Meyer lime juice
1/4 cup simple syrup or agave nectar
10 fresh sweet basil leaves (slapped to release oils)
1.5 cups cold club soda or sparkling mineral water
Crushed ice
Small watermelon wedges & basil sprigs for garnish',
'Step 1: Watermelon Pureeing - Place chilled watermelon cubes in a blender. Blend on high for 45 seconds until completely liquefied.
Step 2: Fine Straining - Pour pureed watermelon through a fine-mesh sieve into a pitcher, pressing lightly with a spatula to yield clear, vibrant red juice.
Step 3: Lime & Sweetener - Stir fresh lime juice and agave nectar into the watermelon juice.
Step 4: Basil Bruising - Bruise fresh basil leaves with a muddler in the bottom of the pitcher to release herbal aromatic oils.
Step 5: Glass Setup - Fill highball glasses with crushed ice.
Step 6: Pouring Juice - Pour watermelon-basil juice over the ice, filling glasses three-quarters full.
Step 7: Sparkling Top - Top with cold sparkling club soda; stir gently once with a bar spoon.
Step 8: Garnish - Garnish glass rim with a triangular watermelon wedge and fresh basil sprig.',
'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Tow_Glass_of_Watermelon_Juice.jpg/960px-Tow_Glass_of_Watermelon_Juice.jpg'),

(97, 7, 'Authentic Sri Lankan Ginger Tea (Inguru Kahata) with Pure Bee Honey', 'Beverages', 'Sri Lanka (Upcountry Herbal Hearth Heritage)', 12,
'3 cups fresh spring water
2 inches fresh pungent ginger root (washed, skin left on, and crushed flat in a granite mortar)
2 tbsp premium Ceylon Broken Orange Pekoe (BOP) black tea leaves
2 tbsp pure Sri Lankan wild bee honey or warm kithul jaggery pieces
1/2 fresh lime (optional for lime tea twist)',
'Step 1: Crushing Ginger - Wash unpeeled ginger thoroughly (the skin contains earthy essential aromatics). Place in a heavy stone mortar and pound vigorously with the pestle until completely crushed flat and juicy.
Step 2: Ginger Water Decoction - In a saucepan, bring water and crushed ginger to a rolling boil over medium-high heat. Boil for 6-8 minutes until the liquid turns pale amber and smells spicy.
Step 3: Brewing Ceylon BOP - Add Ceylon black tea leaves. Boil for 90 seconds to extract deep tea notes without tannin bitterness.
Step 4: Straining - Pour tea through a fine-mesh brass or cloth tea strainer into ceramic cups.
Step 5: Honey Sweetening - Stir in pure wild bee honey while warm until dissolved.
Step 6: Lime Twist - If desired, squeeze 3 drops of fresh lime juice into the cup (the amber tea will brighten instantly to ruby-orange).
Step 7: Traditional Accompaniment - In authentic Sri Lankan village tradition, serve plain hot ginger tea alongside small bite-sized pieces of dark Kithul jaggery to nibble between sips.
Step 8: Service - Enjoy hot to soothe throat and revitalize digestion.',
'https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Moroccan_Mint_Tea_-_1.jpg/960px-Moroccan_Mint_Tea_-_1.jpg'),

(98, 16, 'Rich Italian Thick Hot Chocolate (Cioccolata Calda) with Dark Valrhona', 'Beverages', 'Italy (Turin, Piedmont - Bicerin Heritage)', 15,
'150g premium dark chocolate (Valrhona 70% cacao, finely chopped)
2 cups whole milk
2 tbsp Dutch-process unsweetened cocoa powder
2 tbsp granulated sugar
1.5 tbsp cornstarch (Italian secret for luxurious spoon-thick pudding consistency)
1 pinch fine sea salt
Unsweetened whipped cream for topping',
'Step 1: Chopping Chocolate - Finely chop dark chocolate on a cutting board so it melts instantly upon hitting warm milk.
Step 2: Slurry Whisking - In a small bowl, whisk cornstarch and cocoa powder with 1/3 cup cold milk until completely smooth and lump-free.
Step 3: Warming Milk - Heat remaining milk and sugar in a heavy saucepan over medium heat until warm and steaming.
Step 4: Incorporating Slurry - Whisk the cocoa-cornstarch slurry into the warm milk. Cook over medium-low heat, whisking constantly.
Step 5: Thickening Phase - As the milk reaches a simmer, the cornstarch activates. Whisk continuously for 2 minutes as the mixture thickens into a glossy, velvety custard-like consistency.
Step 6: Melting Dark Chocolate - Remove saucepan from heat. Add chopped dark chocolate and a pinch of salt. Whisk vigorously until chocolate is completely melted and silky.
Step 7: Return to Heat - Return to low heat for 60 seconds, whisking until smooth and thick enough to coat a spoon heavily.
Step 8: Service - Pour hot thick chocolate into small ceramic cups. Top with a dollop of unsweetened whipped cream and eat with a spoon.',
'https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/Hot_Chocolate_in_December.jpg/960px-Hot_Chocolate_in_December.jpg'),

(99, 5, 'Sparkling Blue Ocean Mocktail with Blue Curaçao Syrup & Citrus', 'Beverages', 'Caribbean / Tropical Resort Heritage', 5,
'2 tbsp non-alcoholic Blue Curaçao orange syrup
2 tbsp fresh lime juice
1/2 cup fresh white grapefruit juice or lemonade
1 cup sparkling lemon-lime soda or club soda
1 cup crushed ice
Fresh mint sprig, lime wheel, and Maraschino cherry for garnish',
'Step 1: Citrus Foundation - In a shaker or glass, combine fresh lime juice and lemonade/grapefruit juice.
Step 2: Glass Prep - Fill a tall hurricane glass or highball glass with crushed ice.
Step 3: Blue Curaçao Base - Pour Blue Curaçao syrup directly into the bottom of the glass.
Step 4: Ice Layering - Pack ice tightly over the blue syrup.
Step 5: Citrus Pour - Slowly pour the lemonade over the back of a spoon to create an ombre effect.
Step 6: Sparkling Top - Top the glass with chilled sparkling lemon-lime soda.
Step 7: Stir Swirl - Swirl gently with a bar spoon to watch the brilliant turquoise ocean wave gradient form.
Step 8: Garnish - Garnish rim with a lime wheel, fresh mint sprig, and Maraschino cherry.',
'assets/images/recipes/blue-ocean-mocktail.jpg'),

(100, 28, 'Vietnamese Iced Avocado Smoothie (Sinh Tố Bơ) with Sweet Condensed Milk', 'Beverages', 'Vietnam (Da Lat & Saigon Street Beverage Culture)', 10,
'2 large ripe Hass avocados (buttery flesh scooped out, soft to gentle pressure)
1/3 cup sweetened condensed milk (Lon Sữa Ông Thọ)
1/4 cup whole milk or coconut milk
1.5 cups crushed ice
1 tsp fresh lime juice (prevents oxidation and balances rich sweetness)
Drizzle of condensed milk and toasted coconut flakes for glass garnish',
'Step 1: Avocado Selection - Choose ripe avocados with dark pebbled skin that yield gently to thumb pressure without being mushy. Halve, remove pit, and scoop out green buttery flesh.
Step 2: Blender Loading - Place avocado flesh into a high-powered blender pitcher.
Step 3: Sweet Condensed Milk - Pour in sweet condensed milk, whole milk, and 1 tsp fresh lime juice.
Step 4: Crushed Ice Addition - Add 1.5 cups of crushed ice.
Step 5: High-Shear Blending - Blend on high speed for 60 to 90 seconds until the ice and avocado fuse into an ultra-thick, luscious, pale-green frozen milkshake consistency.
Step 6: Glass Decor - Drizzle thick sweet condensed milk in decorative ribbons along the inner walls of two tall glasses.
Step 7: Pouring Smoothie - Pour the creamy Sinh Tố Bơ into the glasses using a spatula to guide the thick mixture.
Step 8: Garnish & Street Service - Top with a drizzle of condensed milk and crunchy toasted coconut flakes. Serve immediately with a wide boba straw.',
'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Sinh_t%E1%BB%91_b%C6%A1.jpg/960px-Sinh_t%E1%BB%91_b%C6%A1.jpg');

INSERT INTO `ratings` (`recipe_id`, `user_ip_or_id`, `rating`) VALUES
(1, '127.0.0.1', 5), (1, '192.168.1.10', 5), (1, '192.168.1.11', 4),
(2, '127.0.0.1', 5), (2, '192.168.1.12', 4),
(3, '127.0.0.1', 5), (3, '192.168.1.13', 5), (3, '192.168.1.14', 5),
(18, '127.0.0.1', 5), (18, '192.168.1.15', 5), (18, '192.168.1.16', 5), (18, '192.168.1.17', 4),
(19, '127.0.0.1', 4), (19, '192.168.1.18', 5),
(22, '127.0.0.1', 5), (22, '192.168.1.19', 5),
(26, '127.0.0.1', 5), (26, '192.168.1.20', 5), (26, '192.168.1.21', 5),
(35, '127.0.0.1', 5), (35, '192.168.1.22', 5), (35, '192.168.1.23', 4),
(36, '127.0.0.1', 5), (36, '192.168.1.24', 5),
(37, '127.0.0.1', 5), (37, '192.168.1.25', 5),
(43, '127.0.0.1', 5), (43, '192.168.1.26', 5), (43, '192.168.1.27', 5),
(52, '127.0.0.1', 5), (52, '192.168.1.28', 5), (52, '192.168.1.29', 5),
(53, '127.0.0.1', 5), (53, '192.168.1.30', 5),
(54, '127.0.0.1', 5), (54, '192.168.1.31', 4),
(69, '127.0.0.1', 5), (69, '192.168.1.32', 5), (69, '192.168.1.33', 4),
(70, '127.0.0.1', 5), (70, '192.168.1.34', 4),
(71, '127.0.0.1', 5), (71, '192.168.1.35', 5),
(85, '127.0.0.1', 5), (85, '192.168.1.36', 5), (85, '192.168.1.37', 5),
(87, '127.0.0.1', 5), (87, '192.168.1.38', 5),
(93, '127.0.0.1', 5), (93, '192.168.1.39', 5);

-- -----------------------------------------------------------------------------
-- Seed Sample Contact Messages
-- -----------------------------------------------------------------------------
INSERT INTO `messages` (`name`, `email`, `message`) VALUES
('Kamal Gunaratne', 'kamal@example.com', 'Great website! The Sri Lankan chicken curry recipe turned out amazing.'),
('Nimali Fernando', 'nimali@example.com', 'Could you please add more gluten-free breakfast recipes? Thank you!');

-- -----------------------------------------------------------------------------
-- Sync Instructions Column with Steps
-- -----------------------------------------------------------------------------
UPDATE `recipes` SET `instructions` = `steps` WHERE `instructions` IS NULL OR `instructions` = '';
