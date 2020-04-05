<template>
  <div id="bibleModal" class="modal">
    <div class="modal-content">
    	<span class="close" @click="closeModal">&times;</span>
    	<div class="scroll" v-html="htmlContent"></div>
    </div>
  </div>
</template>

<script>
  import mine from '../mine';

  export default {
    name: 'BibleModal',
    props: {
      bibleRef: String,
    },
    data() {
      let defaultContent = '<div class="loader"></div>';
      return {
        htmlContent: defaultContent,
      }
    },
    mounted() {
      let url = 'http://labs.bible.org/api/?type=json&formatting=full&passage=';
      url = url.concat(this.bibleRef.split('_').join(' ').split(';').join('%3B'));
      mine.getRequestWithoutAuth('/passage?type=json&formatting=full&passage=' + this.bibleRef.split('_').join(' ').split(';').join('%3B')).then((passage) => {
          console.log(passage);
          var tempContent = '';
          var book = '';
          var chapter = '0';
          for (var i = 0; i < passage.length; i++) {
            if (book != passage[i].bookname || chapter != passage[i].chapter){
              book = passage[i].bookname;
              chapter = passage[i].chapter;
              tempContent = tempContent.concat('<h4 class="bible-verse">' + book + ' ' + chapter + '</h4>');
            }
            if (passage[i].title) {
              tempContent = tempContent.concat('<h4 class="bible-verse">' + passage[i].title + '</h4>');
            }
            tempContent = tempContent.concat('<sup>' + passage[i].verse + '</sup>');
            tempContent = tempContent.concat(passage[i].text);
          }
          this.htmlContent = tempContent;
        }
      );
    },
    methods: {
      closeModal() {
        this.$parent.closeBibleModal();
      }
    }
  };
</script>

<style>
  .modal {
    position: fixed;
    z-index: 9999;
    left: 0;
    top: 0;
    width: 100%; /* Full width */
    height: 100%; /* Full height */
    overflow: auto; /* Enable scroll if needed */
    background-color: rgb(0,0,0); /* Fallback color */
    background-color: rgba(0,0,0,0.5); /* Black w/ opacity */
  }

  .modal-content {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    max-height: 80%;
    padding: 20px;
    border-radius:4px;
    border: 0;
    background-color:#E0E5EC;
    box-shadow: 3px 3px 6px rgb(163,177,198,0.6), -3px -3px 6px    rgba(255,255,255, 0.5);
    width: 80%; /* Could be more or less, depending on screen size */
    max-width: 400px;
  }

  .scroll {
    display: block;
    position: relative;
  	overflow-y: scroll;
  	max-height: 500px;
  }

  .close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
  }

  .close:hover,
  .close:focus {
    color: black;
    text-decoration: none;
  }

  .bible-verse {
    color: #000000;
  }

  .loader {
  position: relative;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  border: 16px solid #f3f3f3;
  border-radius: 50%;
  border-top: 5px solid #81ecec;
  border-right: 5px solid #fab1a0;
  border-bottom: 5px solid #00b894;
  border-left: 5px solid #ffeaa7;
  width: 50px;
  height: 50px;
  -webkit-animation: spin 2s linear infinite;
  animation: spin 2s linear infinite;
}

@-webkit-keyframes spin {
  0% { -webkit-transform: rotate(0deg); }
  100% { -webkit-transform: rotate(360deg); }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>