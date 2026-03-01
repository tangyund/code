<template>
  <div class="home-container">
    <h1 class="title">徐州特色旅游美食分享平台</h1>

    <el-carousel :interval="4000" type="card" height="400px">
      <el-carousel-item v-for="(item, index) in carouselImages" :key="index">
        <img :src="item.url" class="carousel-image" :alt="item.alt" />
      </el-carousel-item>
    </el-carousel>
    <div class="content">
        <p>欢迎来到徐州特色旅游美食分享平台！在这里，你可以发现徐州最地道、最美味的特色美食，以及相关的旅游攻略。我们致力于为你提供最全面的徐州美食信息，让你在旅途中尽情享受美食的乐趣。</p>
        <p>徐州，这座历史悠久的城市，不仅有丰富的文化底蕴，还有令人垂涎欲滴的美食。从地锅鸡到羊肉汤，从把子肉到烙馍卷馓子，每一道菜都蕴含着徐州人民的热情和智慧。我们希望通过这个平台，让更多的人了解徐州美食，爱上徐州。</p>
         <p>
            <strong>特色美食推荐：</strong>
            <ul>
                <li>地锅鸡：徐州特色名菜，香辣可口，回味无穷。</li>
                <li>羊肉汤：冬季滋补佳品，汤鲜肉嫩，暖心暖胃。</li>
                <li>把子肉：肥而不腻，入口即化，搭配米饭绝佳。</li>
                <li>烙馍卷馓子：徐州传统小吃，酥脆可口，风味独特。</li>
            </ul>
        </p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const baseUrl = import.meta.env.BASE_URL;

const carouselImages = ref([
    { url: `${baseUrl}images/diguoji.jpeg`, alt: '地锅鸡' },
    { url: `${baseUrl}images/yangroutang.jpeg`, alt: '羊肉汤' },
    { url: `${baseUrl}images/bazirou.jpeg`, alt: '把子肉' },
     { url: `${baseUrl}images/laomojuan.jpeg`, alt: '烙馍卷馓子' },
]);
</script>

<style scoped>
.home-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
}

.title {
  margin-bottom: 20px;
  color: #333;
  text-align: center;
}

.el-carousel {
  width: 80%;
  max-width: 800px;
  margin-bottom: 20px;
}

.carousel-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 8px;
}
.content{
    width: 80%;
    max-width: 800px;
    text-align: left;
    line-height: 1.6;
    margin-bottom: 20px;
}
.content ul {
    padding-left: 20px;
    list-style-type: disc;
}

@media screen and (max-width: 768px) {
  .el-carousel {
    width: 95%;
  }
  .content {
    width: 95%;
  }
}
</style>
